{{ config(materialized='table') }}

select * from {{ ref("ext_races-driver-standings") }}
