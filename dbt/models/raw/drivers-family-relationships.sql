{{ config(materialized='table') }}

select * from {{ ref('ext_drivers-family-relationships') }}
