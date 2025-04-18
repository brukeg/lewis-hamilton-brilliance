{{ config(
    materialized='table',
    cluster_by=["positionNumber", "driverId"]
) }}

select * from {{ ref("ext_seasons-driver-standings") }}
