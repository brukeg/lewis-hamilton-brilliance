{{ config(materialized='table') }}

select * from {{ ref("ext_races-race-results") }}
