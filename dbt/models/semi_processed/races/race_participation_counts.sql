{{ config(
  materialized='table',
  cluster_by=["driver_id"]
) }}

SELECT
  driverId AS driver_id,
  COUNT(DISTINCT raceId) AS race_count
FROM {{ source('raw', 'races-race-results') }}
GROUP BY driverId
