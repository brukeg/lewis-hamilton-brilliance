{%- materialization external, adapter='bigquery' -%}
  {# Retrieve external configuration from the model’s config. #}
  {%- set ext_config = config.get('external') -%}
  {%- if ext_config is none -%}
    {{ exceptions.raise_compiler_error("Missing external configuration. Please provide an 'external' config block.") }}
  {%- endif -%}

  {# Get the fully qualified target relation for this model (its table name and dataset). #}
  {%- set target_relation = this.incorporate(type='table') -%}

  {# Extract the required settings from the external config. We require 'location',
     and we take 'format' (defaulting to "CSV") and 'skip_leading_rows'. #}
  {%- set location = ext_config.get("location") -%}
  {%- if not location -%}
    {{ exceptions.raise_compiler_error("Missing 'location' in external config.") }}
  {%- endif -%}
  
  {%- set file_format = ext_config.get("format", "CSV") | upper -%}
  {%- set skip_leading_rows = ext_config.get("skip_leading_rows", 0) -%}

  {# Build the DDL for creating or replacing an external table. #}
  {%- set ddl -%}
    CREATE OR REPLACE EXTERNAL TABLE {{ target_relation.render() }}
    OPTIONS(
      format = '{{ file_format }}',
      uris = ['{{ location }}'],
      skip_leading_rows = {{ skip_leading_rows }}
    )
  {%- endset -%}

  {{ log("Creating external table with DDL: " ~ ddl, info=True) }}

  {# Use a statement block named "main" to run the DDL.
     This satisfies dbt’s expectation that a statement called "main" is executed.
  #}
  {% call statement('main', fetch_result=True) %}
    {{ ddl }}
  {% endcall %}

  {# Return the target relation in the expected dictionary format. #}
  {{ return({ "relations": [target_relation] }) }}
{%- endmaterialization -%}
