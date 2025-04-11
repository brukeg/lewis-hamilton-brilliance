-- Question: How often has he started on the front row?
-- Table: driver_front_row_starts.sql
-- Directory: models/semi_processed

{{ config(materialized='table') }}

SELECT
  driverId,
  COUNT(*) AS front_row_starts
FROM {{ source('raw', 'races-race-results') }}
WHERE gridPositionNumber <= 2
GROUP BY driverId
