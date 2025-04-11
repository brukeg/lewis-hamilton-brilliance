-- Question: Pole position per driver

{{ config(materialized='table') }}

SELECT
  driverId AS driver_id,
  COUNT(*) AS pole_count
FROM {{ source('raw', 'races-race-results') }}
WHERE gridPositionNumber = 1
GROUP BY driverId
