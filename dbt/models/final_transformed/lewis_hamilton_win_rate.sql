{{ config(materialized='table') }}

SELECT *
FROM {{ source('semi_processed', 'driver_win_rates') }}
WHERE driver_id = 'lewis-hamilton'