{{ config(
  materialized='table',
  cluster_by=["season", "champion_id", "runner_up_id"]
) }}

WITH ranked_standings AS (
  SELECT
    year AS season,
    driverId AS driver_id,
    points,
    RANK() OVER (PARTITION BY year ORDER BY positionNumber) AS position_rank
  FROM {{ source('raw','seasons-driver-standings') }}
)
SELECT
  s1.season,
  s1.driver_id AS champion_id,
  s1.points AS champion_points,
  s2.driver_id AS runner_up_id,
  s2.points AS runner_up_points,
  s1.points - s2.points AS point_gap
FROM ranked_standings s1
JOIN ranked_standings s2
  ON s1.season = s2.season AND s1.position_rank = 1 AND s2.position_rank = 2
