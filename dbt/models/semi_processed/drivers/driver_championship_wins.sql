-- Question: Championships won per driver?

{{ config(materialized='table') }}

SELECT
  driverId AS driver_id,
  COUNT(*) AS championships_won
FROM {{ source('raw', 'races-race-results') }}
WHERE positionNumber = 1
GROUP BY driver_id
