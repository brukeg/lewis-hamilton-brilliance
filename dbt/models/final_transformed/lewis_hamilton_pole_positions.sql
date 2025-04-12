{{ config(materialized='table') }}

SELECT *
FROM {{ source('semi_processed', 'driver_pole_positions') }}
WHERE driver_id = 'lewis-hamilton'