-- Question: In how many seasons did he win the championship?
-- Table: driver_championship_wins.sql
-- Directory: models/semi_processed

{{ config(materialized='table') }}

SELECT
  driverId AS driver_id,
  COUNT(*) AS championships_won
FROM {{ source('raw', 'races-race-results') }}
WHERE positionNumber = 1
GROUP BY driver_id
