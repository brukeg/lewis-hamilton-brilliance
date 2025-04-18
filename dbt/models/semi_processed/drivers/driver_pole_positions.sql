{{ config(
  materialized='table',
  cluster_by=["driver_id"]
) }}

SELECT
  driverId AS driver_id,
  COUNT(*) AS pole_count
FROM {{ source('raw', 'races-race-results') }}
WHERE gridPositionNumber = 1
GROUP BY driverId
