{ config(materialized='table') }
SELECT * FROM { ref('races-qualifying-1-results') }
