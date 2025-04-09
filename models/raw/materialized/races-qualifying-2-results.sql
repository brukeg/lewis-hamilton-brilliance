{ config(materialized='table') }
SELECT * FROM { ref('races-qualifying-2-results') }
