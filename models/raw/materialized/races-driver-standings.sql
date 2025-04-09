{ config(materialized='table') }
SELECT * FROM { ref('races-driver-standings') }
