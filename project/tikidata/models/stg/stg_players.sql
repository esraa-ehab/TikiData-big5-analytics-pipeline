with stg_players as (
    select * from {{ source('raw', 'raw_players') }}
)

select
    "Player" as player_name,
    "Nation" as country_id,
    "Rk" as rank,
    split("Pos", ',')[0] as main_position,
    split("Pos", ',')[1] as second_position,
    "Squad" as team_id,
    "Season" - "Age" -1 as birth_year,
    "Weekly Wages" as weekly_wages,
    "Season" as season_id
from
    stg_players