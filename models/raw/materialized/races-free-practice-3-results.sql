{ config(materialized='table') }
SELECT * FROM { ref('races-free-practice-3-results') }
