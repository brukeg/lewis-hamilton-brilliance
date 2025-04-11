-- Question: Who are the all-time greatest based on championships, race wins, and poles?

{{ config(materialized='table') }}

WITH championships AS (
  SELECT
    driverId AS driver_id,
    COUNT(*) AS championships
  FROM {{ source('raw', 'seasons-driver-standings') }}
  WHERE positionNumber = 1
  GROUP BY driver_id
),
wins AS (
  SELECT
    driverId AS driver_id,
    COUNT(*) AS race_wins
  FROM {{ source('raw', 'races-race-results') }}
  WHERE positionNumber = 1
  GROUP BY driverId
),
poles AS (
  SELECT
    driverId AS driver_id,
    COUNT(*) AS pole_positions
  FROM {{ source('raw', 'races-race-results') }}
  WHERE gridPositionNumber = 1
  GROUP BY driverId
)
SELECT
  COALESCE(c.driver_id, w.driver_id, p.driver_id) AS driver_id,
  COALESCE(c.championships, 0) AS championships,
  COALESCE(w.race_wins, 0) AS race_wins,
  COALESCE(p.pole_positions, 0) AS pole_positions
FROM championships c
FULL OUTER JOIN wins w ON c.driver_id = w.driver_id
FULL OUTER JOIN poles p ON COALESCE(c.driver_id, w.driver_id) = p.driver_id
