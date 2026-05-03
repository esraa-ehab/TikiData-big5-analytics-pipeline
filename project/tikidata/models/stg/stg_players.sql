with stg_players as (
    select * from {{ source('RAW', 'raw_players') }}
)

select
    "Player" as player_name,
    "Nation" as country_id,
    split("Pos", ',')[0] as main_position,
    split("Pos", ',')[1] as second_position,
    "Squad" as team_name,
    "Season" - "Age" -1 as birth_year,
    "Age" as player_age,
    "Annual Wages" as annual_wages,
    "Season" as season
from
    stg_players