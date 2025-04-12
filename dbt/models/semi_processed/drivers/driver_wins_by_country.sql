-- Total wins per driver in each country

{{ config(materialized='table') }}

SELECT
  rr.driverId AS driver_id,
  c.countryId AS country_id,
  COUNT(*) AS win_count
FROM {{ source('raw', 'races-race-results') }} rr
JOIN {{ source('raw', 'races') }} r ON rr.raceId = r.id
JOIN {{ source('raw', 'circuits') }} c ON r.circuitId = c.id
WHERE rr.positionNumber = 1
GROUP BY rr.driverId, c.countryId