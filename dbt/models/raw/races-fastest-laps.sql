{{ config(materialized='table') }}

select * from {{ ref('ext_races-fastest-laps') }}
