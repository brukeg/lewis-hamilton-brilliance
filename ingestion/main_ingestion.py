import click
import sys
import logging
from manage_raw_data import run_ingestion

@click.group()
def cli():
    """
    CLI for running ingestion and DBT transformation tasks.
    
    This script is designed to run inside the ingestion container.
    The "ingest" command runs the ingestion workflow defined in manage_raw_data.py.
    The "transform" command runs dbt (if installed in this container).
    """
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s')

@cli.command()
def ingest():
    """Run the full ingestion process."""
    try:
        click.echo("Starting ingestion process...")
        # Call the ingestion workflow (download, extract, version check, upload, cleanup)
        run_ingestion()
        click.echo("Ingestion process completed successfully.")
    except Exception as e:
        click.echo(f"Ingestion error: {e}")
        logging.exception("Ingestion encountered an error:")
        sys.exit(1)


if __name__ == "__main__":
    cli()
