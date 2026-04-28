{{
  config(
    materialized = 'view'
    )
}}

with stg_league as (
    select distinct
        "League_id" as league_id,
        "League_name" as league_name,
        "Country" as country
    from {{ source('RAW', 'raw_leagues') }}
)
select * from stg_league