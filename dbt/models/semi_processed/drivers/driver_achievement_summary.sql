{{ config(
  materialized='table',
  cluster_by=["driver_id"]
) }}

SELECT
  driverId AS driver_id,
  COUNT(*) AS total_races,
  COUNTIF(positionNumber = 1) AS total_wins,
  COUNTIF(gridPositionNumber = 1) AS total_poles,
  COUNTIF(positionNumber <= 3) AS total_podiums,
  COUNTIF(fastestLap = TRUE) AS fastest_laps
FROM {{ source('raw', 'races-race-results') }}
GROUP BY driverId
