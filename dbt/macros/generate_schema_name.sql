{% macro generate_schema_name(custom_schema_name, node) -%}
  {%- set default_schema = target.schema -%}
  {%- if node.config.materialized == 'external' -%}
    {# If materialized as external, route to a dedicated external dataset #}
    {{ return('dbt_staging_external') }}
  {%- else -%}
    {# Otherwise use the default dataset from your profile #}
    {{ return(default_schema) }}
  {%- endif -%}
{%- endmacro %}
