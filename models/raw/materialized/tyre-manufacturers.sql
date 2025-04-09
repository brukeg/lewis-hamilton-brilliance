{ config(materialized='table') }
SELECT * FROM { ref('tyre-manufacturers') }
