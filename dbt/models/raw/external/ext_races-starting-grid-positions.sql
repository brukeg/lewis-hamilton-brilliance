{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-races-starting-grid-positions.csv",
         "format": "csv",
         "skip_leading_rows": 1,
         "schema": "
            raceId INT64, 
            year INT64, 
            round INT64, 
            positionDisplayOrder INT64, 
            positionNumber INT64, 
            positionText STRING, 
            driverNumber INT64, 
            driverId STRING, 
            constructorId STRING, 
            engineManufacturerId STRING, 
            tyreManufacturerId STRING, 
            qualificationPositionNumber INT64, 
            qualificationPositionText STRING, 
            gridPenalty STRING, 
            gridPenaltyPositions STRING, 
            time STRING, 
            timeMillis INT64
            "
    }
) }}

select * from external
