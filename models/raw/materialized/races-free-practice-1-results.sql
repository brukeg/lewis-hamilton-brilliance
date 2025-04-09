{ config(materialized='table') }
SELECT * FROM { ref('races-free-practice-1-results') }
