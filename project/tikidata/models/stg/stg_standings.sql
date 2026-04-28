with stg_standings as (
    select * from {{ source('RAW', 'raw_standings') }}
)

select 
    "Rk" as rank,
    "Squad" as team_id,
    "League" as league_id,
    "Season" as season_id,
    "MP" as matches_played,
    "W" as wins,
    "D" as draws,
    "L" as losses,
    "GF" as goals_scored,
    "GA" as goals_conceded,
    "Pts" as points,
    "Pts/MP" as points_per_matches,
    "Attendance" as attendance,
    "Top Team Scorer" as top_scorer,
    "Goalkeeper" as goalkeeper
from
    stg_standings