{{ config(materialized='table') }}

select * from {{ ref('ext_seasons-constructor-standings') }}
