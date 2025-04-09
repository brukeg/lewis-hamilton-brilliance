{ config(materialized='table') }
SELECT * FROM { ref('chassis') }
