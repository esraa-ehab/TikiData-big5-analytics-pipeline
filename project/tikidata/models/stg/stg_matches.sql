with stg_matches as (
    select * from RAW.DBT_DEV_RAW_TABLES.MATCHES_TABLE
)

select 
    ROW_NUMBER() over (order by "date") as match_id,
    "date" as match_date,
    "time" as match_time,
    "team" as team_id,
    "opponent" as opponent_team_id,
    "round" as round,
    "venue" as venue,
    "GF" as "goals_scored",
    "GA" as "goals_conceded",
    "Poss" as possession,
    "Attendance",
    "Captain" as player_id,
    "Formation" as team_formation_id,
    "Opp Formation" as opponent_formation_id,
    "season_2" as season_id,
    "league" as league_id
from
    stg_matches