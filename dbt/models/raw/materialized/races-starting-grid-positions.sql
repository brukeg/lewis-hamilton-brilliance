{{ config(materialized='table') }}

select * from {{ ref("ext_races-starting-grid-positions") }}
