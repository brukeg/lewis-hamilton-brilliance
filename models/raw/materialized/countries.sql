{ config(materialized='table') }
SELECT * FROM { ref('countries') }
