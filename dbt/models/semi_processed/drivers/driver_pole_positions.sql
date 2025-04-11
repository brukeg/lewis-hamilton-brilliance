-- Question: How often has he started from pole position?
-- Table: driver_pole_positions.sql
-- Directory: models/semi_processed

{{ config(materialized='table') }}

SELECT
  driverId AS driver_id,
  COUNT(*) AS pole_count
FROM {{ source('raw', 'races-race-results') }}
WHERE gridPositionNumber = 1
GROUP BY driverId
