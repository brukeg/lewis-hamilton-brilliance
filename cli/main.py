import subprocess
import click
import os

@click.group()
def cli():
    """CLI for Lewis Hamilton Data Pipeline"""
    pass

@cli.command()
def ingest():
    """Ingest raw data using manage_raw_data.py"""
    click.echo("Ingesting raw data...")
    subprocess.run(["python", "ingestion/manage_raw_data.py"], check=True)

@cli.command()
@click.option('--target', required=True, help='dbt target to run (e.g., dev, semi, final)')
def transform(target):
    """Run dbt transformations for a given target"""
    click.echo(f"Running dbt models for target: {target}")
    subprocess.run(["dbt", "run", "--target", target], cwd="dbt", check=True)

@cli.command()
def run_pipeline():
    """Run full pipeline: ingest and all dbt transformations"""
    click.echo("Starting full pipeline...")
    subprocess.run(["python", "ingestion/manage_raw_data.py"], check=True)
    for target in ["dev", "semi", "final"]:
        click.echo(f"Running dbt models for target: {target}")
        subprocess.run(["dbt", "run", "--target", target], cwd="dbt", check=True)

if __name__ == "__main__":
    cli()
