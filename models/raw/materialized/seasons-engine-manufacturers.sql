{ config(materialized='table') }
SELECT * FROM { ref('seasons-engine-manufacturers') }
