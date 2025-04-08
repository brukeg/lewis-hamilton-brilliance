{ config(materialized='table') }
SELECT * FROM { ref('seasons-driver-standings') }
