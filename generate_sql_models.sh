#!/bin/bash

mkdir -p models/raw/external
mkdir -p models/raw/materialized

# External models: each file includes a config block with materialized='external' and an "external" key.
# The location includes the full file name, e.g., "f1db-chassis.csv".
# Feel free to update the bucket name and any option as needed.

cat <<EOF > models/raw/external/chassis.sql
{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-chassis.csv",
         "format": "csv",
         "skip_leading_rows": 1
    }
) }}

select * from external
EOF

cat <<EOF > models/raw/external/circuits.sql
{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-circuits.csv",
         "format": "csv",
         "skip_leading_rows": 1
    }
) }}

select * from external
EOF

cat <<EOF > models/raw/external/constructors-chronology.sql
{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-constructors-chronology.csv",
         "format": "csv",
         "skip_leading_rows": 1
    }
) }}

select * from external
EOF

cat <<EOF > models/raw/external/constructors.sql
{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-constructors.csv",
         "format": "csv",
         "skip_leading_rows": 1
    }
) }}

select * from external
EOF

cat <<EOF > models/raw/external/continents.sql
{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-continents.csv",
         "format": "csv",
         "skip_leading_rows": 1
    }
) }}

select * from external
EOF

cat <<EOF > models/raw/external/countries.sql
{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-countries.csv",
         "format": "csv",
         "skip_leading_rows": 1
    }
) }}

select * from external
EOF

cat <<EOF > models/raw/external/drivers-family-relationships.sql
{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-drivers-family-relationships.csv",
         "format": "csv",
         "skip_leading_rows": 1
    }
) }}

select * from external
EOF

cat <<EOF > models/raw/external/drivers.sql
{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-drivers.csv",
         "format": "csv",
         "skip_leading_rows": 1
    }
) }}

select * from external
EOF

cat <<EOF > models/raw/external/engine-manufacturers.sql
{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-engine-manufacturers.csv",
         "format": "csv",
         "skip_leading_rows": 1
    }
) }}

select * from external
EOF

cat <<EOF > models/raw/external/engines.sql
{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-engines.csv",
         "format": "csv",
         "skip_leading_rows": 1
    }
) }}

select * from external
EOF

cat <<EOF > models/raw/external/entrants.sql
{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-entrants.csv",
         "format": "csv",
         "skip_leading_rows": 1
    }
) }}

select * from external
EOF

cat <<EOF > models/raw/external/grands-prix.sql
{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-grands-prix.csv",
         "format": "csv",
         "skip_leading_rows": 1
    }
) }}

select * from external
EOF

cat <<EOF > models/raw/materialized/chassis.sql
{ config(materialized='table') }
SELECT * FROM { ref('chassis') }
EOF

cat <<EOF > models/raw/materialized/circuits.sql
{ config(materialized='table') }
SELECT * FROM { ref('circuits') }
EOF

cat <<EOF > models/raw/materialized/constructors-chronology.sql
{ config(materialized='table') }
SELECT * FROM { ref('constructors-chronology') }
EOF

cat <<EOF > models/raw/materialized/constructors.sql
{ config(materialized='table') }
SELECT * FROM { ref('constructors') }
EOF

cat <<EOF > models/raw/materialized/continents.sql
{ config(materialized='table') }
SELECT * FROM { ref('continents') }
EOF

cat <<EOF > models/raw/materialized/countries.sql
{ config(materialized='table') }
SELECT * FROM { ref('countries') }
EOF

cat <<EOF > models/raw/materialized/drivers-family-relationships.sql
{ config(materialized='table') }
SELECT * FROM { ref('drivers-family-relationships') }
EOF

cat <<EOF > models/raw/materialized/drivers.sql
{ config(materialized='table') }
SELECT * FROM { ref('drivers') }
EOF

cat <<EOF > models/raw/materialized/engine-manufacturers.sql
{ config(materialized='table') }
SELECT * FROM { ref('engine-manufacturers') }
EOF

cat <<EOF > models/raw/materialized/engines.sql
{ config(materialized='table') }
SELECT * FROM { ref('engines') }
EOF

cat <<EOF > models/raw/materialized/entrants.sql
{ config(materialized='table') }
SELECT * FROM { ref('entrants') }
EOF

cat <<EOF > models/raw/materialized/grands-prix.sql
{ config(materialized='table') }
SELECT * FROM { ref('grands-prix') }
EOF

cat <<EOF > models/raw/materialized/races-constructor-standings.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-constructor-standings') }
EOF

cat <<EOF > models/raw/materialized/races-driver-of-the-day-results.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-driver-of-the-day-results') }
EOF

cat <<EOF > models/raw/materialized/races-driver-standings.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-driver-standings') }
EOF

cat <<EOF > models/raw/materialized/races-fastest-laps.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-fastest-laps') }
EOF

cat <<EOF > models/raw/materialized/races-free-practice-1-results.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-free-practice-1-results') }
EOF

cat <<EOF > models/raw/materialized/races-free-practice-2-results.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-free-practice-2-results') }
EOF

cat <<EOF > models/raw/materialized/races-free-practice-3-results.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-free-practice-3-results') }
EOF

cat <<EOF > models/raw/materialized/races-free-practice-4-results.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-free-practice-4-results') }
EOF

cat <<EOF > models/raw/materialized/races-pit-stops.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-pit-stops') }
EOF

cat <<EOF > models/raw/materialized/races-pre-qualifying-results.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-pre-qualifying-results') }
EOF

cat <<EOF > models/raw/materialized/races-qualifying-1-results.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-qualifying-1-results') }
EOF

cat <<EOF > models/raw/materialized/races-qualifying-2-results.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-qualifying-2-results') }
EOF

cat <<EOF > models/raw/materialized/races-qualifying-results.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-qualifying-results') }
EOF

cat <<EOF > models/raw/materialized/races-race-results.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-race-results') }
EOF

cat <<EOF > models/raw/materialized/races-sprint-qualifying-results.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-sprint-qualifying-results') }
EOF

cat <<EOF > models/raw/materialized/races-sprint-race-results.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-sprint-race-results') }
EOF

cat <<EOF > models/raw/materialized/races-sprint-starting-grid-positions.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-sprint-starting-grid-positions') }
EOF

cat <<EOF > models/raw/materialized/races-starting-grid-positions.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-starting-grid-positions') }
EOF

cat <<EOF > models/raw/materialized/races-warming-up-results.sql
{ config(materialized='table') }
SELECT * FROM { ref('races-warming-up-results') }
EOF

cat <<EOF > models/raw/materialized/races.sql
{ config(materialized='table') }
SELECT * FROM { ref('races') }
EOF

cat <<EOF > models/raw/materialized/seasons-constructor-standings.sql
{ config(materialized='table') }
SELECT * FROM { ref('seasons-constructor-standings') }
EOF

cat <<EOF > models/raw/materialized/seasons-constructors.sql
{ config(materialized='table') }
SELECT * FROM { ref('seasons-constructors') }
EOF

cat <<EOF > models/raw/materialized/seasons-driver-standings.sql
{ config(materialized='table') }
SELECT * FROM { ref('seasons-driver-standings') }
EOF

cat <<EOF > models/raw/materialized/seasons-drivers.sql
{ config(materialized='table') }
SELECT * FROM { ref('seasons-drivers') }
EOF

cat <<EOF > models/raw/materialized/seasons-engine-manufacturers.sql
{ config(materialized='table') }
SELECT * FROM { ref('seasons-engine-manufacturers') }
EOF

cat <<EOF > models/raw/materialized/seasons-entrants-chassis.sql
{ config(materialized='table') }
SELECT * FROM { ref('seasons-entrants-chassis') }
EOF

cat <<EOF > models/raw/materialized/seasons-entrants-constructors.sql
{ config(materialized='table') }
SELECT * FROM { ref('seasons-entrants-constructors') }
EOF

cat <<EOF > models/raw/materialized/seasons-entrants-drivers.sql
{ config(materialized='table') }
SELECT * FROM { ref('seasons-entrants-drivers') }
EOF

cat <<EOF > models/raw/materialized/seasons-entrants-engines.sql
{ config(materialized='table') }
SELECT * FROM { ref('seasons-entrants-engines') }
EOF

cat <<EOF > models/raw/materialized/seasons-entrants-tyre-manufacturers.sql
{ config(materialized='table') }
SELECT * FROM { ref('seasons-entrants-tyre-manufacturers') }
EOF

cat <<EOF > models/raw/materialized/seasons-entrants.sql
{ config(materialized='table') }
SELECT * FROM { ref('seasons-entrants') }
EOF

cat <<EOF > models/raw/materialized/seasons-tyre-manufacturers.sql
{ config(materialized='table') }
SELECT * FROM { ref('seasons-tyre-manufacturers') }
EOF

cat <<EOF > models/raw/materialized/seasons.sql
{ config(materialized='table') }
SELECT * FROM { ref('seasons') }
EOF

cat <<EOF > models/raw/materialized/tyre-manufacturers.sql
{ config(materialized='table') }
SELECT * FROM { ref('tyre-manufacturers') }
EOF