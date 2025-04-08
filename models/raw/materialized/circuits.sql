{ config(materialized='table') }
SELECT * FROM { ref('circuits') }
