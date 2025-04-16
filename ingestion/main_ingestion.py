import click
import sys
import logging
from manage_raw_data import run_ingestion

@click.group()
def cli():
    """
    CLI for executing the ingestion workflow for raw F1DB data.
    
    This script is designed to run inside the ingestion container.
    It provides a single "ingest" command that triggers the full ingestion process
    defined in manage_raw_data.py (which includes tasks such as downloading, 
    extracting, version checking, and uploading raw data). Use the --help option
    for more details on the available command.
    """
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s')

@cli.command()
def ingest():
    """
    Execute the full ingestion workflow for raw F1DB data.
    
    This command performs the entire sequence of ingestion operations:
      - Downloads the specified ZIP file containing raw data.
      - Extracts the contents of the ZIP file.
      - Checks the version of the new data against the current version.
      - If a new version is detected, clears out the existing data,
        updates the version file, and uploads the data to GCS.
      - Cleans up any temporary working directories.
    
    Any errors encountered during the process are logged and will exit the process.
    """
    try:
        click.echo("Starting ingestion process...")
        run_ingestion()
        click.echo("Ingestion process completed successfully.")
    except Exception as e:
        click.echo(f"Ingestion error: {e}")
        logging.exception("Ingestion encountered an error:")
        sys.exit(1)


if __name__ == "__main__":
    cli()
