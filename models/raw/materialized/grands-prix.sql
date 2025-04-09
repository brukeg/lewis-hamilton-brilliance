{ config(materialized='table') }
SELECT * FROM { ref('grands-prix') }
