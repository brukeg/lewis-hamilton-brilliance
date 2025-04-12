{{ config(materialized='table') }}

SELECT *
FROM {{ source('semi_processed', 'championship_points_gap') }}
WHERE champion_id = 'lewis-hamilton'
