{ config(materialized='table') }
SELECT * FROM { ref('continents') }
