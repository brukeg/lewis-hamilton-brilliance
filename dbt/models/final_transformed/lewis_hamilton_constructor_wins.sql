{{ config(materialized='table') }}

SELECT *
FROM {{ source('semi_processed', 'driver_constructor_wins') }}
WHERE driver_id = 'lewis-hamilton'
