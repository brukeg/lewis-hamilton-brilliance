import os
from google.cloud import storage
from typing import NoReturn

"""
upload_to_gcs.py

Module for uploading files to Google Cloud Storage.
"""


def upload_file(bucket_name: str, source_file_path: str, destination_blob_name: str) -> NoReturn:
    """
    Upload a single file to a GCS bucket.

    Args:
        bucket_name (str): The GCS bucket name.
        source_file_path (str): The local path of the file to upload.
        destination_blob_name (str): The destination path in the bucket.
    """
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)
    blob.upload_from_filename(source_file_path)
    print(f"Uploaded {source_file_path} to {destination_blob_name}.")


def upload_directory(bucket_name: str, local_directory: str, gcs_directory: str) -> NoReturn:
    """
    Recursively upload a local directory to a GCS bucket.

    Args:
        bucket_name (str): The GCS bucket name.
        local_directory (str): The local directory path.
        gcs_directory (str): The GCS directory (prefix) where files will be uploaded.
    """
    for root, _, files in os.walk(local_directory):
        for file in files:
            local_path = os.path.join(root, file)
            relative_path = os.path.relpath(local_path, local_directory)
            destination_blob_name = os.path.join(gcs_directory, relative_path)
            upload_file(bucket_name, local_path, destination_blob_name)