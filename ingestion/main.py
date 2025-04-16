import click
import sys
import logging
import os
from manage_raw_data import run_ingestion

@click.group()
def cli():
    """
    CLI entry point for the ingestion container.

    This script is designed to be run inside the ingestion container.
    It exposes a single command, "ingest", which runs the ingestion workflow defined
    in manage_raw_data.py. The workflow includes version checking, downloading,
    extracting, and uploading F1DB raw data to GCS.

    Example:
        python main.py ingest

    Use the --help flag with any command to view detailed usage information.
    """
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s')

@cli.command()
@click.option('--force', is_flag=True, default=False, help='Force ingestion even if version matches.')
def ingest(force):
    """
    Run the full ingestion process from within the ingestion container.

    This command performs the following tasks:
      - Downloads the latest version of the raw F1DB data.
      - Extracts its contents.
      - Compares the extracted version with the local version.
      - If the version is new (or if --force is passed):
            * Clears the raw data directory.
            * Moves new files into place.
            * Updates the version file.
            * Uploads the data to the configured GCS bucket.
            * Cleans up all temporary directories.

    If no new version is detected and --force is not specified, the command exits early.

    Example:
        python main.py ingest
        python main.py ingest --force
    """
    try:
        click.echo("Starting ingestion process...")
        run_ingestion(force=force)
        click.echo("Ingestion process completed successfully.")
    except Exception as e:
        click.echo(f"Ingestion error: {e}")
        logging.exception("Ingestion encountered an error:")
        sys.exit(1)


if __name__ == "__main__":
    cli()
