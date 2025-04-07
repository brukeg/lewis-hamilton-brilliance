import os
import shutil
import tempfile

import pytest

from ingestion.manage_raw_data import (
    parse_version_from_url,
    get_current_version,
    update_version_file,
    clear_directory,
)

"""
Unit tests for ingestion functions.
"""


def test_parse_version_from_url():
    url = "https://github.com/f1db/f1db/releases/download/v2025.3.0/f1db-csv.zip"
    version = parse_version_from_url(url)
    assert version == "2025.3.0"

    bad_url = "https://example.com/f1db-csv.zip"
    version_none = parse_version_from_url(bad_url)
    assert version_none is None


def test_version_file(tmp_path):
    # Create a temporary raw directory
    raw_dir = tmp_path / "raw"
    raw_dir.mkdir()
    # Initially, no version exists
    assert os.path.exists(str(raw_dir))
    assert not os.path.exists(os.path.join(str(raw_dir), "version.txt"))

    # Update the version file and check retrieval
    update_version_file(str(raw_dir), "2025.3.0")
    version = get_current_version(str(raw_dir))
    assert version == "2025.3.0"


def test_clear_directory(tmp_path):
    # Create a temporary directory with files and a subdirectory
    test_dir = tmp_path / "test_clear"
    test_dir.mkdir()
    file1 = test_dir / "file1.txt"
    file1.write_text("hello")
    sub_dir = test_dir / "subdir"
    sub_dir.mkdir()
    file2 = sub_dir / "file2.txt"
    file2.write_text("world")
    # Ensure files exist
    assert file1.exists()
    assert file2.exists()

    # Clear the directory
    clear_directory(str(test_dir))
    # Directory should be empty
    assert list(test_dir.iterdir()) == []
