{ config(materialized='table') }
SELECT * FROM { ref('races-sprint-race-results') }
