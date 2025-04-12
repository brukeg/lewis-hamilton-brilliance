{{ config(materialized='table') }}

SELECT *
FROM {{ source('semi_processed', 'driver_achievement_summary') }}
WHERE driver_id = 'lewis-hamilton'
