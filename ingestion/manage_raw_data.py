import argparse
import os
import shutil
import re
import logging
from typing import Optional

from extract_data import download_zip, extract_zip
from upload_to_gcs import upload_directory

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


def parse_version_from_url(url: str) -> Optional[str]:
    """
    Extract the version string from the given URL.

    This function searches the URL for a pattern of the form "/vYYYY.M.D" 
    (e.g. "/v2025.3.0") and returns the extracted version string.

    Args:
        url (str): The URL from which to extract the version.

    Returns:
        Optional[str]: The version string (e.g. "2025.3.0") if found; otherwise, None.
    """
    match = re.search(r'/v(\d{4}\.\d+\.\d+)', url)
    if match:
        return match.group(1)
    return None


def get_current_version(raw_dir: str) -> Optional[str]:
    """
    Retrieve the current version stored in the raw data directory.

    This function checks for a file named "version.txt" within the specified directory.
    If the file exists, it reads and returns the contained version string (with leading/trailing whitespace removed).

    Args:
        raw_dir (str): The local directory where raw data and the version file are stored.

    Returns:
        Optional[str]: The current version string if the file exists; otherwise, None.
    """
    version_file = os.path.join(raw_dir, "version.txt")
    if os.path.exists(version_file):
        with open(version_file, "r") as f:
            return f.read().strip()
    return None


def update_version_file(raw_dir: str, version: str) -> None:
    """
    Write the new version string to the version file in the raw data directory.

    This function creates (or overwrites) a file named "version.txt" in the provided directory,
    writing the new version string into it.

    Args:
        raw_dir (str): The directory where the version file is stored.
        version (str): The new version string to be saved.

    Returns:
        None
    """
    version_file = os.path.join(raw_dir, "version.txt")
    with open(version_file, "w") as f:
        f.write(version)


def clear_directory(directory: str) -> None:
    """
    Remove all files, symlinks, and subdirectories from the specified directory.

    This function iterates through all entries in the given directory and:
      - Unlinks (deletes) files or symbolic links.
      - Recursively removes any directories.

    Args:
        directory (str): The path of the directory to be cleared.

    Returns:
        None
    """
    for filename in os.listdir(directory):
        file_path = os.path.join(directory, filename)
        if os.path.isfile(file_path) or os.path.islink(file_path):
            os.unlink(file_path)
        elif os.path.isdir(file_path):
            shutil.rmtree(file_path)


def manage_ingestion(url: str, local_raw_dir: str, bucket_name: str, gcs_raw_prefix: str) -> None:
    """
    Orchestrate the full ingestion workflow for raw F1DB data.

    The workflow includes:
      1. Ensuring the local raw data directory exists.
      2. Parsing a new version string from the specified URL.
      3. Comparing the new version to the current version stored locally.
      4. If a new version is detected:
            - Creating temporary directories for download and extraction.
            - Downloading the ZIP file from the URL.
            - Extracting the ZIP file contents.
            - Moving the extracted files to a temporary location and then into the raw data directory.
            - Updating the version file with the new version.
            - Uploading the new raw data to a specified GCS bucket under the given prefix.
            - Cleaning up temporary directories.
      5. If the new version matches the current version, the ingestion process is skipped.

    Args:
        url (str): The URL of the F1DB CSV ZIP file.
        local_raw_dir (str): The local directory path for raw data storage.
        bucket_name (str): The name of the GCS bucket for data upload.
        gcs_raw_prefix (str): The GCS folder prefix (e.g., 'raw/latest') where data should be stored.

    Returns:
        None
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


def run_ingestion(url: str = None, raw_dir: str = None, bucket: str = None, gcs_prefix: str = None) -> None:
    """
    Run the ingestion workflow using provided parameters or environment defaults.

    This function is designed for use both programmatically or via a command-line interface.
    It accepts optional parameters for the URL, raw data directory, GCS bucket, and GCS prefix.
    If any parameter is not provided, the function defaults to the corresponding environment variable.
    If any required parameter is missing, it raises a ValueError.

    Args:
        url (str, optional): URL of the F1DB CSV ZIP file. Defaults to the 'F1DB_RELEASE_URL' environment variable.
        raw_dir (str, optional): Local directory for raw data storage. Defaults to the 'RAW_DATA_DIR' environment variable.
        bucket (str, optional): GCS bucket name for data upload. Defaults to the 'GCS_BUCKET' environment variable.
        gcs_prefix (str, optional): GCS folder prefix for data storage. Defaults to the 'GCS_PREFIX' environment variable.

    Returns:
        None

    Raises:
        ValueError: If any of the required parameters (url, raw_dir, bucket, gcs_prefix) are missing.
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

    manage_ingestion(url, raw_dir, bucket, gcs_prefix)


def main() -> None:
    """
    Entry point for the standalone CLI for ingestion.

    This function uses argparse to parse command-line arguments (falling back on environment variables if necessary)
    and then initiates the ingestion workflow by calling manage_ingestion() with the parsed parameters.

    Returns:
        None
    """
    parser = argparse.ArgumentParser(description="Ingest and manage raw F1DB data.")
    parser.add_argument("--url", default=os.environ.get("F1DB_RELEASE_URL"), help="URL of the F1DB CSV ZIP file.")
    parser.add_argument("--raw_dir", default=os.environ.get("RAW_DATA_DIR"), help="Local directory for raw data storage.")
    parser.add_argument("--bucket", default=os.environ.get("GCS_BUCKET"), help="GCS bucket name for raw data.")
    parser.add_argument("--gcs_prefix", default=os.environ.get("GCS_PREFIX"), help="GCS folder prefix (e.g., 'raw/latest').")
    args = parser.parse_args()
    manage_ingestion(args.url, args.raw_dir, args.bucket, args.gcs_prefix)


if __name__ == '__main__':
    main()
