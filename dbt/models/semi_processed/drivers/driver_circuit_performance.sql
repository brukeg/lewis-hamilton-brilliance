-- Question: In which circuits has he been most dominant?
-- Table: driver_circuit_performance.sql
-- Directory: models/semi_processed

{{ config(materialized='table') }}

SELECT
  driverId AS driver_id,
  raceId AS circuit,
  COUNT(*) AS races,
  COUNTIF(positionNumber = 1) AS wins,
  COUNTIF(gridPositionNumber = 1) AS poles,
  COUNTIF(positionNumber <= 3) AS podiums
FROM {{ source('raw', 'races-race-results') }}
GROUP BY driverId, raceId
