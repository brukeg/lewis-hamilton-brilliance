{{ config(materialized='table') }}

select * from {{ ref("ext_races-constructor-standings") }}
