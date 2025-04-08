{ config(materialized='table') }
SELECT * FROM { ref('engine-manufacturers') }
