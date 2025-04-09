{ config(materialized='table') }
SELECT * FROM { ref('races-race-results') }
