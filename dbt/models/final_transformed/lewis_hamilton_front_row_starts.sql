{{ config(materialized='table') }}

SELECT *
FROM {{ source('semi_processed', 'driver_front_row_starts') }}
WHERE driver_id = 'lewis-hamilton'