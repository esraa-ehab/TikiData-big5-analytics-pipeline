{{
  config(
    materialized = 'view'
    )
}}

with stg_players as (
    select * from {{ source('RAW', 'raw_players') }}
)

select
    concat('ps', ROW_NUMBER() over (ORDER BY "Player")) as player_stats_id,
    "Player" as player_name,
    "Nation" as country_id,
    "Rk" as rank,
    split("Pos", ',')[0] as main_position,
    split("Pos", ',')[1] as second_position,
    "Squad" as team_name,
    "Season" - "Age" -1 as birth_year,
    "Weekly Wages" as weekly_wages,
    "Season" as season
from
    stg_players