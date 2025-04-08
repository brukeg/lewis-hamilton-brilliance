{ config(materialized='table') }
SELECT * FROM { ref('seasons-tyre-manufacturers') }
