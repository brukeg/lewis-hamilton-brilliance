import subprocess
import click
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent
INGEST_SCRIPT = PROJECT_ROOT / "ingestion" / "manage_raw_data.py"
DBT_DIR = PROJECT_ROOT / "dbt"

@click.group()
def cli():
    """CLI for Lewis Hamilton Data Pipeline"""
    pass

@cli.command()
def ingest():
    """Ingest raw data using manage_raw_data.py"""
    click.echo("Ingesting raw data...")
    try:
        subprocess.run(["python", str(INGEST_SCRIPT)], check=True)
    except subprocess.CalledProcessError as e:
        click.echo(f"❌ Ingestion failed: {e}", err=True)
        raise SystemExit(e.returncode)

@cli.command()
@click.option('--target', required=True, help='dbt target to run (e.g., dev, semi, final)')
@click.option('--select', help='Optionally select specific dbt models (e.g., model_name, +tag:tagname)')
def transform(target, select):
    """Run dbt transformations for a given target"""
    click.echo(f"Running dbt models for target: {target}")
    cmd = ["dbt", "run", "--target", target]
    if select:
        cmd.extend(["--select", select])
    try:
        subprocess.run(cmd, cwd=DBT_DIR, check=True)
    except subprocess.CalledProcessError as e:
        click.echo(f"❌ dbt run failed for target {target}: {e}", err=True)
        raise SystemExit(e.returncode)

@cli.command()
def run_pipeline():
    """Run full pipeline: ingest and all dbt transformations"""
    click.echo("Starting full pipeline...")
    try:
        subprocess.run(["python", str(INGEST_SCRIPT)], check=True)
        for target in ["dev", "semi", "final"]:
            click.echo(f"Running dbt models for target: {target}")
            subprocess.run(["dbt", "run", "--target", target], cwd=DBT_DIR, check=True)
    except subprocess.CalledProcessError as e:
        click.echo(f"Pipeline failed: {e}", err=True)
        raise SystemExit(e.returncode)

if __name__ == "__main__":
    cli()


