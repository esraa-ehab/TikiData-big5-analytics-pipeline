with fact_standing as (
    select 
        p.player_id,
        {{ dbt_utils.generate_surrogate_key(['standing_id']) }} as standings_sk,
        lg.league_sk,
        szn.season,
        tm.team_sk,
        p.unique_player_sk as top_scorer_sk,
        stnd.top_scorer_goals,
        gk.unique_player_sk as goalkeaper_sk,
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
    left join {{ ref('dim_team') }} as tm
        on stnd.team_id = tm.team_id
    left join {{ ref('int_seasons') }} as szn
        on stnd.season_id = szn.season_id

    left join {{ ref('dim_league') }} as lg
        on stnd.league_id = lg.league_id

    left join {{ ref('dim_unique_player') }} as p
        on p.player_id = stnd.top_scorer_id

    left join {{ ref('dim_unique_player') }} as gk
        on gk.player_id = stnd.goalkeeper_id
)
select * from fact_standing