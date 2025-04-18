{{ config(
    materialized='table',
    cluster_by=["positionNumber", "driverId", "gridPositionNumber"]
) }}

select * from {{ ref("ext_races-race-results") }}
