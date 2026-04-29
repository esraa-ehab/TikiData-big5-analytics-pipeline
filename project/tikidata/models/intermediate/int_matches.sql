with int_matches as (select 
    concat(t1.team_id, t2.team_id,s.season_id) as match_id,
    case
        when m.league_id = 'FRA-Ligue 1' then 'FL1'
        when m.league_id = 'ENG-Premier League' then 'PL'
        when m.league_id = 'ESP-La Liga' then 'LL'
        when m.league_id = 'ITA-Serie A' then 'SA'
        when m.league_id = 'GER-Bundesliga' then 'BL1'
    End as league_id,
    s.season_id,
    m.match_date,
    m.match_time,
    t1.team_id,
    t2.team_id as opponent_team_id,
    m.round,
    m.venue,
    m."goals_scored" as goals_scored,
    m."goals_conceded" as goals_conceded,
    m.possession,
    m."Attendance" as attendance,
    up.player_id as captain_id,
    f1.formation_id as team_formation_id,
    f2.formation_id as opponent_formation_id
from
   {{ ref('stg_matches') }} m join {{ ref('stg_teams') }} t1
    on m.team_id = t1.team_name
    join {{ ref('stg_teams') }} t2 on m.opponent_team_id = t2.team_name
    join {{ ref('stg_formations') }} f1 on f1."formations" = m.team_formation_id
    join {{ ref('stg_formations') }} f2 on f2."formations" = m.opponent_formation_id
    join {{ ref('stg_unique_players') }} up on up.player_name = m.player_id
    join {{ ref('stg_seasons') }} s on s.season = m.season_id
)

select * from int_matches