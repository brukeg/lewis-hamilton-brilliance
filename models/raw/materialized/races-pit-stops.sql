{ config(materialized='table') }
SELECT * FROM { ref('races-pit-stops') }
