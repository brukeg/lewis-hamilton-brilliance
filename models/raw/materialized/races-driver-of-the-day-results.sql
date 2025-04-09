{ config(materialized='table') }
SELECT * FROM { ref('races-driver-of-the-day-results') }
