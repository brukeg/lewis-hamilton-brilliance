{ config(materialized='table') }
SELECT * FROM { ref('races-qualifying-results') }
