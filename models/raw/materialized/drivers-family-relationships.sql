{ config(materialized='table') }
SELECT * FROM { ref('drivers-family-relationships') }
