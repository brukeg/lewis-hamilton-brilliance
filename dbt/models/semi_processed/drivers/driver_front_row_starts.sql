-- Question: Front row start by driver?

{{ config(materialized='table') }}

SELECT
  driverId as driver_id,
  COUNT(*) AS front_row_starts
FROM {{ source('raw', 'races-race-results') }}
WHERE gridPositionNumber <= 2
GROUP BY driverId
