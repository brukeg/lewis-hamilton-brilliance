{{ config(materialized='table') }}

select * from {{ ref("ext_races-warming-up-results") }}
