{ config(materialized='table') }
SELECT * FROM { ref('races-warming-up-results') }
