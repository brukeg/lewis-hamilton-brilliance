{{ config(materialized='table') }}

select * from {{ ref('ext_races-free-practice-2-results') }}
