{ config(materialized='table') }
SELECT * FROM { ref('seasons-entrants-tyre-manufacturers') }
