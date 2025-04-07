import argparse
import os
import shutil
import re
import logging
from typing import Optional

from extract_data import download_zip, extract_zip
from upload_to_gcs import upload_directory

"""
manage_raw_data.py

Main script to manage the ingestion of raw F1DB data.

This script:
  - Downloads the ZIP file from a given URL.
  - Extracts its contents.
  - Parses the version from the URL.
  - Compares the new version to the currently stored version in the local raw data directory.
  - If the new version is different, it clears the raw data directory, updates the version file,
    and uploads the new data to a GCS bucket.
"""

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

def parse_args():
    """
    Parse command-line arguments or fall back to environment variables.

    Returns:
        argparse.Namespace: The parsed arguments.
    """
    parser = argparse.ArgumentParser(description="Ingest and manage raw F1DB data.")
    parser.add_argument("--url", default=os.environ.get("F1DB_RELEASE_URL"), help="URL of the F1DB CSV ZIP file.")
    parser.add_argument("--raw_dir", default=os.environ.get("RAW_DATA_DIR"), help="Local directory for raw data storage.")
    parser.add_argument("--bucket", default=os.environ.get("GCS_BUCKET"), help="GCS bucket name for raw data.")
    parser.add_argument("--gcs_prefix", default=os.environ.get("GCS_PREFIX"), help="GCS folder prefix (e.g., 'raw/latest').")
    return parser.parse_args()

def parse_version_from_url(url: str) -> Optional[str]:
    match = re.search(r'/v(\d{4}\.\d+\.\d+)', url)
    if match:
        return match.group(1)
    return None

def get_current_version(raw_dir: str) -> Optional[str]:
    version_file = os.path.join(raw_dir, "version.txt")
    if os.path.exists(version_file):
        with open(version_file, "r") as f:
            return f.read().strip()
    return None

def update_version_file(raw_dir: str, version: str) -> None:
    version_file = os.path.join(raw_dir, "version.txt")
    with open(version_file, "w") as f:
        f.write(version)

def clear_directory(directory: str) -> None:
    for filename in os.listdir(directory):
        file_path = os.path.join(directory, filename)
        if os.path.isfile(file_path) or os.path.islink(file_path):
            os.unlink(file_path)
        elif os.path.isdir(file_path):
            shutil.rmtree(file_path)

def manage_ingestion(url: str, local_raw_dir: str, bucket_name: str, gcs_raw_prefix: str) -> None:
    """
    Manage the entire ingestion process:
      - Download and extract the ZIP file.
      - Compare the version with the current version.
      - If the version is new, clear the raw directory, update it with new data, and upload to GCS.

    Args:
        url (str): URL of the F1DB CSV ZIP file.
        local_raw_dir (str): Local directory for raw data.
        bucket_name (str): GCS bucket name.
        gcs_raw_prefix (str): GCS folder prefix (e.g., 'raw/latest').
    """
    os.makedirs(local_raw_dir, exist_ok=True)

    new_version = parse_version_from_url(url)
    if new_version is None:
        logging.error("Could not parse version from URL.")
        return

    current_version = get_current_version(local_raw_dir)
    logging.info(f"Current version: {current_version}, New version: {new_version}")

    if current_version == new_version:
        logging.info("No new version detected. Skipping ingestion.")
        return

    # Set up working dirs
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

    # Final cleanup
    for directory in [download_dir, extract_dir, temp_move_dir]:
        shutil.rmtree(directory, ignore_errors=True)

def main() -> None:
    args = parse_args()
    manage_ingestion(args.url, args.raw_dir, args.bucket, args.gcs_prefix)

if __name__ == "__main__":
    main()
