{ config(materialized='table') }
SELECT * FROM { ref('entrants') }
