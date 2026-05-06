with fact_match as (
    select 
        {{ dbt_utils.generate_surrogate_key(['match_id']) }} as match_sk,
        d.date_sk as date_sk,
        l.league_sk as league_sk,
        s.season as season,
        t1.team_sk as team_sk,
        t2.team_sk as opponent_sk,
        f1.formation as formation,
        f2.formation as opp_formation,
        p.player_sk as captain_sk,
        cast(m.match_time as time) as time,
        m.round as round,
        m.venue as venue,
        cast(m.goals_scored as int) as goals_scored,
        cast(m.goals_conceded as int) as goals_conceded,
        m.possession as possession,
        m.attendance as attendence
    from
        {{ ref('int_matches') }} as m
        join {{ ref('dim_date') }} d
            on d.full_date = m.match_date
        join {{ ref('dim_league') }} l
            on l.league_id = m.league_id
        join {{ ref('int_seasons') }} s
            on s.season_id = m.season_id
        join {{ ref('dim_team') }} t1
            on t1.team_id = m.team_id
        join {{ ref('dim_team') }} t2
            on t2.team_id = m.opponent_team_id
        join {{ ref('int_formations') }} f1
            on f1.formation_id = m.team_formation_id
        join {{ ref('int_formations') }} f2
            on f2.formation_id = m.opponent_formation_id
        join {{ ref('dim_player') }} p
            on p.player_id = m.captain_id
)

select * from fact_match