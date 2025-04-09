{ config(materialized='table') }
SELECT * FROM { ref('races-sprint-qualifying-results') }
