{ config(materialized='table') }
SELECT * FROM { ref('seasons-constructor-standings') }
