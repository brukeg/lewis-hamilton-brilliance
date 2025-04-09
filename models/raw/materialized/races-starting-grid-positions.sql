{ config(materialized='table') }
SELECT * FROM { ref('races-starting-grid-positions') }
