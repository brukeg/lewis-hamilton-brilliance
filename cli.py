import click
import subprocess
import sys
import logging

@click.group()
def cli():
    """
    Host CLI for running ingestion and DBT transformation tasks.

    This CLI tool delegates commands to the appropriate Docker containers
    using "docker exec". It is designed to be run from your host machine, which
    must have Docker installed and running. Use this interface to trigger either
    the ingestion process (via the ingestion container) or transformation tasks
    (via the DBT container). For usage details for each command, run:
    
        python host_cli.py <command> --help
    """
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s')

@cli.command(context_settings=dict(ignore_unknown_options=True, allow_extra_args=True))
@click.pass_context
def ingest(ctx):
    """
    Run the full ingestion process via the ingestion container.

    This command forwards any extra arguments supplied (such as --help) to the ingestion
    container's CLI. When executed, it triggers the ingestion workflow by running the
    ingestion container's main_ingestion.py script with the "ingest" subcommand.
    
    The ingestion process includes tasks such as downloading raw data, extracting files,
    performing version checks, updating the local version, uploading data to GCS, and cleaning
    up temporary directories.

    Usage Examples:
      - Run ingestion with default behavior:
            python host_cli.py ingest
      - Display help for the ingestion subcommand:
            python host_cli.py ingest --help

    This command assumes that your ingestion container is named "ingestion" and that the
    script is located at /app/ingestion/main_ingestion.py inside that container.
    """
    try:
        click.echo("Starting ingestion process on host...")
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
@click.option('--target', required=True, help="Specify the DBT target environment (e.g., dev, semi, final).")
@click.option('--select', default="", help="Optionally, select a specific model, tag, or set of models to run. "
                                               "Examples include:\n\n"
                                               "  - A single model name: 'my_model'\n\n"
                                               "  - A tag selector with dependencies: '+tag_name'\n\n"
                                               "  - A combination of selectors as supported by DBT.\n\n"
                                               "If omitted, DBT will run on all models configured for the target.")
def transform(target, select):
    """
    Runs DBT transformations via the DBT container.

    It constructs and runs a command of the form:
    
        docker exec -it dbt dbt run --target <target> [--select <selector>]
    
    Parameters:\n
        --target:\n
            (Required) Specifies the target environment to use for the DBT run.
            The target dictates which schema dbt will use.\n
      
      --select:\n
            (Optional) Allows you to narrow the scope of the DBT run to a particular model, tag, or set of models.\n
                Examples:\n
                    --select my_model\n
                    --select +tag_name\n
                The selector syntax follows DBT's native conventions. If omitted, DBT will run all models associated with the specified target.

    Usage Examples:\n
      - To execute all DBT models on the development target:\n
            python host_cli.py transform --target dev\n
      - To execute a specific model and its dependencies on the final target:\n
            python host_cli.py transform --target final --select +driver_standings

    Upon execution, the command connects to the Docker container named "dbt" (which must be running and have DBT installed)
    and runs the constructed DBT command. Standard output and errors are forwarded back to the host.
    In case of any errors during execution, the process exits with a non-zero status.
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

if __name__ == "__main__":
    cli()
