{{ config(
  materialized='table',
  cluster_by=["driver_id"]
) }}

SELECT
  driverId AS driver_id,
  COUNT(*) AS championships_won
FROM {{ source('raw', 'races-race-results') }}
WHERE positionNumber = 1
GROUP BY driver_id
