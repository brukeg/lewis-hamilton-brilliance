{ config(materialized='table') }
SELECT * FROM { ref('constructors-chronology') }
