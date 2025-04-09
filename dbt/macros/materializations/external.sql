{%- materialization external, adapter='bigquery' -%}

  {%- set ext_config = config.get('external') -%}
  {%- if ext_config is none -%}
    {{ exceptions.raise_compiler_error("Missing external configuration. Please provide an 'external' config block.") }}
  {%- endif -%}

  {# Resolve the target relation (i.e. the fully qualified table name) based on your BigQuery settings #}
  {%- set target_relation = this.incorporate(type='table') -%}

  {# Extract required settings from external config #}
  {%- set location = ext_config.get("location") -%}
  {%- if not location -%}
    {{ exceptions.raise_compiler_error("Missing 'location' in external config.") }}
  {%- endif -%}
  
  {%- set file_format = ext_config.get("format", "CSV") | upper -%}
  {%- set skip_leading_rows = ext_config.get("skip_leading_rows", 0) -%}

  {# If a schema override is provided, build a schema definition string.
     The expectation is that ext_config.schema is a string like:
       "col1 INT64, col2 STRING, qualificationPosition STRING, col4 FLOAT64"
  #}
  {%- if ext_config.get("schema") %}
    {%- set schema_definition = "(" ~ ext_config.get("schema") ~ ")" %}
  {%- else %}
    {%- set schema_definition = "" %}
  {%- endif %}

  {# Construct the CREATE EXTERNAL TABLE DDL.
     This will be something like:
  
     CREATE OR REPLACE EXTERNAL TABLE project.dataset.table [ (column definitions) ]
     OPTIONS(
       format = 'CSV',
       uris = ['gs://.../f1db-...csv'],
       skip_leading_rows = 1
     )
  #}
  {%- set ddl -%}
    CREATE OR REPLACE EXTERNAL TABLE {{ target_relation.render() }} {{ schema_definition }}
    OPTIONS(
      format = '{{ file_format }}',
      uris = ['{{ location }}'],
      skip_leading_rows = {{ skip_leading_rows }}
    )
  {%- endset -%}

  {{ log("Creating external table with DDL: " ~ ddl, info=True) }}

  {# Use a statement block named "main" so that the statement is properly run by dbt #}
  {% call statement('main', fetch_result=True) %}
    {{ ddl }}
  {% endcall %}

  {{ return({ "relations": [target_relation] }) }}
{%- endmaterialization -%}
