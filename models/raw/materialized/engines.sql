{ config(materialized='table') }
SELECT * FROM { ref('engines') }
