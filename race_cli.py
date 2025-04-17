import click
import subprocess
import sys
import logging

@click.group()
def cli():
    """
    Host CLI for running ingestion and DBT transformation tasks.

    Race CLI delegates commands to the appropriate Docker containers
    using "docker exec". It is designed to be run from your host machine, which
    must have Docker installed and running. Use this interface to trigger either
    the ingestion process (via the ingestion container) or transformation tasks
    (via the DBT container). For usage details for each command, run:
    
        python race_cli.py <command> --help
    """
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s')

@cli.command(context_settings=dict(ignore_unknown_options=True, allow_extra_args=True))
@click.option('-f', '--force', is_flag=True, default=False,
              help='Force ingestion even if the new version matches the current version.')
@click.pass_context
def ingest(ctx, force):
    """
    Runs the full ingestion process via the ingestion container.

    This command triggers the ingestion workflow by running
    the ingestion container's main.py script with the "ingest"
    subcommand. Use --force or -f to bypass version checks.

    Any additional flags passed after "ingest" will be forwarded
    to the inner CLI running in the container.
    """
    try:
        click.echo("Starting ingestion process on host...")

        cmd = [
            "docker", "exec", "-it", "ingestion",
            "python", "/app/ingestion/main.py", "ingest"
        ]

        if force and "--force" not in ctx.args and "-f" not in ctx.args:
            cmd.append("--force")

        cmd += ctx.args

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


@cli.group()
def transform():
    """
    Group of DBT transformation commands. Use one of the subcommands:\n
        run: Run DBT models for a specific target.\n
        run_pipeline: Execute the full pipeline across dev, semi, and final targets sequentially.
    """
    pass

@transform.command(name='run')
@click.option('--target', required=True,
              help="Specify the DBT target environment (e.g., dev, semi, final).")
@click.option('--select', default="",
              help="Select a specific model or tag to run. Examples: 'my_model', '+tag_name'.")
def run(target, select):
    """
    Runs DBT transformations for a single target.
    """
    try:
        click.echo("Starting transformation process on host...")
        dbt_cmd = ["dbt", "run", "--target", target]
        if select:
            dbt_cmd.extend(["--select", select])
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

@transform.command(name='run_pipeline')
def run_pipeline():
    """
    Executes the full DBT pipeline: dev -> semi -> final.
    This runs `dbt run` sequentially for each of the three targets.
    """
    targets = ['dev', 'semi', 'final']
    try:
        click.echo("Starting full DBT pipeline on host...")
        for t in targets:
            click.echo(f"Running DBT for target: {t}")
            cmd = ["docker", "exec", "-it", "dbt", "dbt", "run", "--target", t]
            click.echo("Executing: " + " ".join(cmd))
            result = subprocess.run(cmd, capture_output=True, text=True)
            sys.stdout.write(result.stdout)
            if result.returncode != 0:
                click.echo(f"DBT encountered an error on target {t}:")
                sys.stderr.write(result.stderr)
                sys.exit(result.returncode)
        click.echo("DBT pipeline completed successfully.")
    except Exception as e:
        click.echo(f"DBT pipeline error: {e}")
        logging.exception("Error during DBT pipeline:")
        sys.exit(1)

if __name__ == "__main__":
    cli()
