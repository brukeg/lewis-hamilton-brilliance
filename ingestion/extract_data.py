import os
import zipfile
import requests
import logging
import zipfile
from typing import Optional

"""
extract_data.py

Module for downloading and extracting F1DB CSV zip files.
"""


def download_zip(url: str, destination: str) -> str:
    """
    Download a ZIP file from the specified URL and save it to the destination directory.

    Args:
        url (str): The URL of the ZIP file to download.
        destination (str): The directory where the ZIP file should be saved.

    Returns:
        str: The full path to the downloaded ZIP file.
    """
    os.makedirs(destination, exist_ok=True)
    local_filename = os.path.join(destination, url.split("/")[-1])
    
    logging.info(f"Attempting to download file from URL: {url}")
    try:
        with requests.get(url, stream=True) as r:
            r.raise_for_status()
            with open(local_filename, 'wb') as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)
        logging.info(f"Downloaded ZIP file to: {local_filename}")
    except requests.exceptions.RequestException as e:
        logging.error(f"Failed to download ZIP file: {e}")
        raise
    
    if not os.path.exists(local_filename):
        raise FileNotFoundError(f"Expected file was not found after download: {local_filename}")

    return local_filename


def extract_zip(zip_path: str, extract_to: str) -> None:
    """
    Extract the contents of a ZIP file to the specified directory.

    Args:
        zip_path (str): The path to the ZIP file.
        extract_to (str): The directory where files should be extracted.
    """
    logger = logging.getLogger(__name__)

    logger.info(f"Preparing to extract zip file: {zip_path} to {extract_to}")

    if not os.path.exists(zip_path):
        logger.error(f"ZIP file does not exist: {zip_path}")
        raise FileNotFoundError(f"ZIP file does not exist: {zip_path}")

    os.makedirs(extract_to, exist_ok=True)

    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(extract_to)
        extracted_files = zip_ref.namelist()
        logger.info(f"Extracted {len(extracted_files)} files to {extract_to}")
        logger.debug(f"Extracted files: {extracted_files}")
