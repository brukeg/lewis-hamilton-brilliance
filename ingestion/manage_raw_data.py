import argparse
import os
import shutil
import re
import logging
from typing import Optional

from extract_data import download_zip, extract_zip
from upload_to_gcs import upload_directory


logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

def parse_version_from_url(url: str) -> Optional[str]:
    """
    Extract the version string from the release URL.

    Args:
        url (str): The F1DB URL in .env

    Returns:
        Optional[str]: The version string (e.g., '2025.3.0') if matched, else None.
    """
    match = re.search(r'/v(\d{4}\.\d+\.\d+)', url)
    if match:
        return match.group(1)
    return None

def get_current_version(raw_dir: str) -> Optional[str]:
    """
    Reads the current version stored in the version.txt file in the given directory.

    Args:
        raw_dir (str): Path to the directory containing version.txt (data/raw/version.txt).

    Returns:
        Optional[str]: The current version string if available, else None.
    """
    version_file = os.path.join(raw_dir, "version.txt")
    if os.path.exists(version_file):
        with open(version_file, "r") as f:
            return f.read().strip()
    return None

def update_version_file(raw_dir: str, version: str) -> None:
    """
    Updates the version.txt file with the new version string.

    Args:
        raw_dir (str): Path to the directory (data/raw/version.txt).
        version (str): New version string to write.
    """
    version_file = os.path.join(raw_dir, "version.txt")
    with open(version_file, "w") as f:
        f.write(version)

def clear_directory(directory: str) -> None:
    """
    Delete all files and subdirectories in a given directory.

    Args:
        directory (str): Path to the directory to clear.
    """
    for filename in os.listdir(directory):
        file_path = os.path.join(directory, filename)
        if os.path.isfile(file_path) or os.path.islink(file_path):
            os.unlink(file_path)
        elif os.path.isdir(file_path):
            shutil.rmtree(file_path)

def manage_ingestion(url: str, local_raw_dir: str, bucket_name: str, gcs_raw_prefix: str, force: bool = False) -> None:
    """
    Full ingestion pipeline for raw F1DB data.

    Downloads and extracts ZIP, checks version, updates local storage and uploads to GCS.

    Args:
        url (str): Download URL.
        local_raw_dir (str): Local directory to store raw data.
        bucket_name (str): GCS bucket for upload.
        gcs_raw_prefix (str): GCS key prefix for uploaded data.
        force (bool): If True, skips version check and performs ingestion regardless.
    """
    os.makedirs(local_raw_dir, exist_ok=True)

    new_version = parse_version_from_url(url)
    if new_version is None:
        logging.error("Could not parse version from URL.")
        return

    current_version = get_current_version(local_raw_dir)
    logging.info(f"Current version: {current_version}, New version: {new_version}")

    if current_version == new_version and not force:
        logging.info("No new version detected. Skipping ingestion.")
        return

    if force:
        logging.info("Force ingestion.")

    download_dir = os.path.join(local_raw_dir, "download")
    extract_dir = os.path.join(local_raw_dir, "extracted")
    temp_move_dir = os.path.join(local_raw_dir, "temp_raw")

    for d in [download_dir, extract_dir, temp_move_dir]:
        if os.path.exists(d):
            shutil.rmtree(d)
        os.makedirs(d, exist_ok=True)

    zip_path = download_zip(url, download_dir)
    logging.info(f"Downloaded ZIP file to: {zip_path}")

    extract_zip(zip_path, extract_dir)
    logging.info(f"Extracted ZIP file to: {extract_dir}")

    if not os.listdir(extract_dir):
        logging.error(f"Extraction directory is empty: {extract_dir}")
        return

    for item in os.listdir(extract_dir):
        source = os.path.join(extract_dir, item)
        destination = os.path.join(temp_move_dir, item)
        shutil.move(source, destination)

    for item in os.listdir(temp_move_dir):
        shutil.move(os.path.join(temp_move_dir, item), os.path.join(local_raw_dir, item))

    update_version_file(local_raw_dir, new_version)
    logging.info(f"Updated local version to: {new_version}")

    upload_directory(bucket_name, local_raw_dir, gcs_raw_prefix)
    logging.info("Uploaded new raw data to GCS.")

    for directory in [download_dir, extract_dir, temp_move_dir]:
        shutil.rmtree(directory, ignore_errors=True)

def run_ingestion(url: str = None, raw_dir: str = None, bucket: str = None, gcs_prefix: str = None, force: bool = False) -> None:
    """
    Run ingestion with either environment variable or passed parameters.

    Args:
        url (str): F1DB Download URL.
        raw_dir (str): Local storage path.
        bucket (str): GCS bucket name.
        gcs_prefix (str): GCS prefix path.
        force (bool, optional): Bypass version check and ingest anyway.

    Raises:
        ValueError: If any required arguments are missing.
    """
    if url is None:
        url = os.environ.get("F1DB_RELEASE_URL")
    if raw_dir is None:
        raw_dir = os.environ.get("RAW_DATA_DIR")
    if bucket is None:
        bucket = os.environ.get("GCS_BUCKET")
    if gcs_prefix is None:
        gcs_prefix = os.environ.get("GCS_PREFIX")
    if not all([url, raw_dir, bucket, gcs_prefix]):
        raise ValueError("Missing required parameters for ingestion. Please provide URL, RAW_DIR, GCS_BUCKET, and GCS_PREFIX.")

    manage_ingestion(url, raw_dir, bucket, gcs_prefix, force=force)

def main() -> None:
    """
    Entry point for argparse-based CLI ingestion runner.
    """
    parser = argparse.ArgumentParser(description="Ingest and manage raw F1DB data.")
    parser.add_argument("--url", default=os.environ.get("F1DB_RELEASE_URL"), help="URL of the F1DB CSV ZIP file.")
    parser.add_argument("--raw_dir", default=os.environ.get("RAW_DATA_DIR"), help="Local directory for raw data storage (e.g., 'data/raw').")
    parser.add_argument("--bucket", default=os.environ.get("GCS_BUCKET"), help="GCS bucket name for raw data.")
    parser.add_argument("--gcs_prefix", default=os.environ.get("GCS_PREFIX"), help="GCS folder prefix (e.g., 'raw/latest').")
    parser.add_argument("--force", action="store_true", help="Force ingestion regardless of current version.")
    args = parser.parse_args()
    manage_ingestion(args.url, args.raw_dir, args.bucket, args.gcs_prefix, force=args.force)

if __name__ == '__main__':
    main()
