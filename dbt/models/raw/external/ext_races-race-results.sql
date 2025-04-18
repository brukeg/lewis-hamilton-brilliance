{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-races-race-results.csv",
         "format": "csv",
         "skip_leading_rows": 1,
         "partition_by": "raceId",
         "cluster_by": ["positionNumber", "driverId", "gridPositionNumber"]
    }
) }}

select * from external
