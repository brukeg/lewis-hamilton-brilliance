{ config(materialized='table') }
SELECT * FROM { ref('races-sprint-starting-grid-positions') }
