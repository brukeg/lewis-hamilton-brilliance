-- Question: How many races has each driver won at least once? (Unique GP victories)

{{ config(materialized='table') }}

SELECT
  driverId AS driver_id,
  COUNT(DISTINCT raceId) AS unique_gp_wins
FROM {{ source('raw', 'races-race-results') }}
WHERE positionNumber = 1
GROUP BY driver_id
