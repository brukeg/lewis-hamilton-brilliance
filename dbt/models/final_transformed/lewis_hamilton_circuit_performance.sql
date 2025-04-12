{{ config(materialized='table') }}

SELECT *
FROM {{ source('semi_processed', 'driver_circuit_performance') }}
WHERE driver_id = 'lewis-hamilton'
