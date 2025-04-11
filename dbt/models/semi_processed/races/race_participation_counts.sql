-- Question: How many races has each driver competed in?

{{ config(materialized='table') }}

SELECT
  driverId AS driver_id,
  COUNT(DISTINCT raceId) AS race_count
FROM {{ source('raw', 'races-race-results') }}
GROUP BY driverId
