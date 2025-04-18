{{ config(
  materialized='table',
  cluster_by=["driver_id"]
) }}

SELECT
  driverId AS driver_id,
  constructorId AS constructor_id,
  COUNT(*) AS win_count
FROM {{ source('raw', 'races-race-results') }}
WHERE positionNumber = 1
GROUP BY driverId, constructorId
