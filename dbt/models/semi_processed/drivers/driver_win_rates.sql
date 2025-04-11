-- Question: How does his win rate compare to other drivers with 100+ races?
-- Table: driver_win_rates.sql
-- Directory: models/semi_processed

{{ config(materialized='table') }}

WITH race_counts AS (
  SELECT
    driverId AS driver_id,
    COUNT(DISTINCT raceId) AS race_count
  FROM {{ source('raw', 'races-race-results') }}
  GROUP BY driverId
),
win_counts AS (
  SELECT
    driverId AS driver_id,
    COUNT(*) AS win_count
  FROM {{ source('raw', 'races-race-results') }}
  WHERE positionNumber = 1
  GROUP BY driver_id
)
SELECT
  rc.driver_id,
  rc.race_count,
  wc.win_count,
  SAFE_DIVIDE(wc.win_count, rc.race_count) AS win_rate
FROM race_counts rc
LEFT JOIN win_counts wc USING(driver_id)
WHERE rc.race_count >= 100
