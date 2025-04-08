-- models/raw/f1db_races.sql

{{ config(materialized='table') }}

select * from {{ ref('ext_races') }}