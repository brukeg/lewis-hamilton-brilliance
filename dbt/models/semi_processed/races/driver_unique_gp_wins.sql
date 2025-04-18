{{ config(
  materialized='table',
  cluster_by=["driver_id"]
) }}

SELECT
  driverId AS driver_id,
  COUNT(DISTINCT raceId) AS unique_gp_wins
FROM {{ source('raw', 'races-race-results') }}
WHERE positionNumber = 1
GROUP BY driver_id
