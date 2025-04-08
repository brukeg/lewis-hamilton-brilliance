{ config(materialized='table') }
SELECT * FROM { ref('races-free-practice-2-results') }
