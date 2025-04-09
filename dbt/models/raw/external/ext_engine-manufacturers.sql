{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-engine-manufacturers.csv",
         "format": "csv",
         "skip_leading_rows": 1,
         "schema": "
            id STRING,
            name STRING,
            countryId STRING,
            bestChampionshipPosition INT64,
            bestStartingGridPosition INT64,
            bestRaceResult INT64,
            totalChampionshipWins INT64,
            totalRaceEntries INT64,
            totalRaceStarts INT64,
            totalRaceWins INT64,
            totalRaceLaps INT64,
            totalPodiums INT64,
            totalPodiumRaces INT64,
            totalPoints FLOAT64,
            totalChampionshipPoints FLOAT64,
            totalPolePositions INT64,
            totalFastestLaps INT64
         "
    }
) }}

select * from external