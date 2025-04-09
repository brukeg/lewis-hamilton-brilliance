{{ config(materialized='table') }}

select * from {{ ref("ext_races-pre-qualifying-results") }}
