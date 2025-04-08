{{ config(materialized='table') }}

select * from {{ ref('ext_races-free-practice-4-results') }}
