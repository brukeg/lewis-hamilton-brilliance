{{ config(materialized='table') }}

select * from {{ ref("ext_races-qualifying-2-results") }}
