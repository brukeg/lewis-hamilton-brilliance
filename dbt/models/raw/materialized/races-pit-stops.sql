{{ config(materialized='table') }}

select * from {{ ref("ext_races-pit-stops") }}
