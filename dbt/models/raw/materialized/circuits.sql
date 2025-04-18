{{ config(
    materialized='table',
    cluster_by=["id"]
) }}

select * from {{ ref("ext_circuits") }}
