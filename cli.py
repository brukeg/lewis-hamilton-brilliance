import click
import subprocess
import sys
import logging

@click.group()
def cli():
    """
    Host CLI for running ingestion and DBT transformation tasks.

    This CLI delegates commands to the appropriate Docker containers
    using "docker exec". Run this CLI from your host machine (which has Docker installed),
    not from within any container.
    """
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s')

@cli.command(context_settings=dict(ignore_unknown_options=True, allow_extra_args=True))
@click.pass_context
def ingest(ctx):
    """Run the full ingestion process via the ingestion container."""
    try:
        click.echo("Starting ingestion process on host...")
        # Append "ingest" and any extra arguments from the host CLI to the container command.
        # This way, if the user includes --help after "ingest", it will be forwarded.
        cmd = [
            "docker", "exec", "-it", "ingestion",
            "python", "/app/ingestion/main_ingestion.py", "ingest"
        ] + ctx.args

        click.echo("Executing: " + " ".join(cmd))
        result = subprocess.run(cmd, capture_output=True, text=True)
        sys.stdout.write(result.stdout)
        if result.returncode != 0:
            click.echo("Ingestion encountered an error:")
            sys.stderr.write(result.stderr)
            sys.exit(result.returncode)

    except Exception as e:
        click.echo(f"Ingestion error: {e}")
        logging.exception("Error during ingestion:")
        sys.exit(1)

@cli.command()
@click.option('--target', required=True, help="DBT target to use (e.g. dev, final)")
@click.option('--select', default="", help="Select a specific model or tag (optional)")
def transform(target, select):
    """
    Run DBT transformations via the DBT container.

    Example:
      python host_cli.py transform --target dev
      python host_cli.py transform --target final --select +driver_standings
    """
    try:
        click.echo("Starting transformation process on host...")
        # Build the DBT command arguments.
        dbt_cmd = ["dbt", "run", "--target", target]
        if select:
            dbt_cmd.extend(["--select", select])
            
        # Prepend the docker exec command to run dbt in the DBT container.
        cmd = ["docker", "exec", "-it", "dbt"] + dbt_cmd
        
        click.echo("Executing: " + " ".join(cmd))
        result = subprocess.run(cmd, capture_output=True, text=True)
        sys.stdout.write(result.stdout)
        if result.returncode != 0:
            click.echo("DBT encountered an error:")
            sys.stderr.write(result.stderr)
            sys.exit(result.returncode)
        else:
            click.echo("DBT transformation completed successfully.")
    except Exception as e:
        click.echo(f"DBT transformation error: {e}")
        logging.exception("Error during DBT transformation:")
        sys.exit(1)

if __name__ == "__main__":
    cli()
