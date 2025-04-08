{ config(materialized='table') }
SELECT * FROM { ref('seasons-entrants-engines') }
