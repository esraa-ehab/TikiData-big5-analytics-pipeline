with fact_standing as (
    select 
        {{ dbt_utils.generate_surrogate_key(['standing_id']) }} as standings_sk,
        lg.league_sk,
        szn.season,
        tm.team_sk,
        p.player_sk as top_scorer_sk,
        stnd.top_scorer_goals,
        gk.player_sk as goalkeaper_sk,
        stnd.rank,
        stnd.points,
        stnd.matches_played,
        stnd.wins,
        stnd.losses,
        stnd.draws,
        stnd.goals_scored,
        stnd.goals_conceded,
        stnd.avg_points_per_match,
        stnd.attendance,
        
    from {{ ref('int_standings') }} as stnd
    join {{ ref('dim_player') }} as p
        on stnd.top_scorer_id = p.player_id
    join {{ ref('dim_player') }} as gk
        on stnd.goalkeeper_id = gk.player_id
    join {{ ref('dim_team') }} as tm
        on stnd.team_id = tm.team_id
    join {{ ref('int_seasons') }} as szn
        on stnd.season_id = szn.season_id
    join {{ ref('dim_league') }} as lg
        on stnd.league_id = lg.league_id
)
select * from fact_standing