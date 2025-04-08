{ config(materialized='table') }
SELECT * FROM { ref('seasons-constructors') }
