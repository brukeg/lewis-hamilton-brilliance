{{ config(
    materialized='table',
    partition_by={
        "field": "date",
        "data_type": "date"
    },
    cluster_by=["id", "circuitId"]
) }}

select * from {{ ref("ext_races") }}
