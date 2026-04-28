{{
  config(
    materialized = 'view'
    )
}}

with stg_standings as (
    select * from {{ source('RAW', 'raw_standings') }}
)

select 
    "Rk" as rank,
    "Squad" as team_name,
    "League" as league_name,
    "Season" as season,
    "MP" as matches_played,
    "W" as wins,
    "D" as draws,
    "L" as losses,
    "GF" as goals_scored,
    "GA" as goals_conceded,
    "Pts" as points,
    "Pts/MP" as points_per_matches,
    "Attendance" as attendance,
    split("Top Team Scorer", ' - ')[0] as top_scorer,
    split("Top Team Scorer", ' - ')[1] as top_scorer_goals,
    "Goalkeeper" as goalkeeper
from
    stg_standings