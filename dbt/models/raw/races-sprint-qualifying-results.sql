{{ config(materialized='table') }}

select * from {{ ref('ext_races-sprint-qualifying-results') }}
