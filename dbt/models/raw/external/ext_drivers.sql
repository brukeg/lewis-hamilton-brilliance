{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-drivers.csv",
         "format": "csv",
         "skip_leading_rows": 1,
         "schema": "
            id STRING,
            name STRING,
            firstName STRING,
            lastName STRING,
            fullName STRING,
            abbreviation STRING,
            permanentNumber STRING,
            gender STRING,
            dateOfBirth DATE,
            dateOfDeath DATE,
            placeOfBirth STRING,
            countryOfBirthCountryId STRING,
            nationalityCountryId STRING,
            secondNationalityCountryId STRING,
            bestChampionshipPosition INT64,
            bestStartingGridPosition INT64,
            bestRaceResult INT64,
            totalChampionshipWins INT64,
            totalRaceEntries INT64,
            totalRaceStarts INT64,
            totalRaceWins INT64,
            totalRaceLaps INT64,
            totalPodiums INT64,
            totalPoints FLOAT64,
            totalChampionshipPoints FLOAT64,
            totalPolePositions INT64,
            totalFastestLaps INT64,
            totalDriverOfTheDay INT64,
            totalGrandSlams INT64
         ",
         "partition_by": "dateOfBirth",
         "cluster_by": ["id"]
    }
) }}

select * from external