{{ config(materialized='table') }}

select * from {{ ref("ext_races-driver-of-the-day-results") }}
