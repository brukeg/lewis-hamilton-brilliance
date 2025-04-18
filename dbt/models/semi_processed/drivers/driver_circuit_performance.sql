{{ config(
  materialized='table',
  cluster_by=["driver_id"]
) }}

SELECT
  driverId AS driver_id,
  raceId AS circuit,
  COUNT(*) AS races,
  COUNTIF(positionNumber = 1) AS wins,
  COUNTIF(gridPositionNumber = 1) AS poles,
  COUNTIF(positionNumber <= 3) AS podiums
FROM {{ source('raw', 'races-race-results') }}
GROUP BY driverId, raceId
