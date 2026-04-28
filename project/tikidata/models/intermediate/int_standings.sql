with int_standings as (
    select 
        stnd.rank,
        concat(lg.league_id, team.team_id, szn."season_id") as standing_id,
        team.team_id,
        lg.league_id,
        szn."season_id" as season_id,
        stnd.matches_played,
        stnd.points,
        stnd.wins,
        stnd.draws,
        stnd.losses,
        stnd.goals_scored,
        stnd.goals_conceded,
        stnd.points_per_matches as avg_points_per_match,
        stnd.attendance,
        p.player_id as top_scorer_id,
        replace(stnd.top_scorer_goals, '"', '') as top_scorer_goals,
        p1.player_id as goalkeeper_id
        
    from {{ ref(STG_STANDINGS) }} as stnd
    join {{ ref(STG_LEAGUES) }} as lg 
        on stnd.league_name = lg.league_name
    join {{ ref(STG_SEASONS) }} as szn
        on stnd.season = szn."season"
    join {{ ref(STG_TEAMS) }} as team
        on stnd.team_name = team.team_name
    join {{ ref(STG_UNIQUE_PLAYERS) }} as p
        on stnd.top_scorer = p.player_name
    join {{ ref(STG_UNIQUE_PLAYERS) }} as p1
        on stnd.goalkeeper = p1.player_name
)
select * from int_standings