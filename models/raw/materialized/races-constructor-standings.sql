{ config(materialized='table') }
SELECT * FROM { ref('races-constructor-standings') }
