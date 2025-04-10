-- Question: How many wins does he have for each manufacturer he's driven for?
-- Table: driver_constructor_wins.sql
-- Directory: models/semi_processed

{{ config(materialized='table') }}

SELECT
  driveId AS driver_id,
  constructorId AS constructor_id,
  COUNT(*) AS win_count
FROM {{ source('raw', 'races_race_results') }}
WHERE positionNumber = 1
GROUP BY driverId, constructorId
