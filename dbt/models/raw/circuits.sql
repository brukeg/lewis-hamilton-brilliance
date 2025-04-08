{{ config(materialized='table') }}

select * from {{ ref('ext_circuits') }}
