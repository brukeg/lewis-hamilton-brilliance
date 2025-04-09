{ config(materialized='table') }
SELECT * FROM { ref('constructors') }
