with int_player as (
    select 
        p.player_stats_id,
        up.player_id,
        p.rank,
        lg.league_id,
        p.country_id,
        pos.position_id as main_position_id,
        pos1.position_id as second_position_id,
        tm.team_id,
        p.birth_year,
        to_number(replace(regexp_substr(p.weekly_wages, '£\\s*([0-9,]+)', 1, 1, 'e', 1), ',', '')) as weekly_wage_gbp,
        to_number(replace(regexp_substr(p.weekly_wages, '€\\s*([0-9,]+)', 1, 1, 'e', 1), ',', '')) as weekly_wage_eur,
        to_number(replace(regexp_substr(p.weekly_wages, '\\$\\s*([0-9,]+)', 1, 1, 'e', 1), ',', '')) as weekly_wage_usd,
        szn.season_id
        
    from {{ ref('stg_players') }} as p
    join {{ ref('stg_unique_players') }} as up
        on p.player_name = up.player_name
    join {{ ref('stg_teams') }} as tm
        on p.team_name = tm.team_name
    join {{ ref('stg_leagues') }} as lg
        on tm.league_name = lg.league_name
    join {{ ref('stg_seasons') }} as szn
        on p.season = szn.season
    left join {{ ref('stg_positions') }} as pos
        on pos.position = replace(p.main_position, '"', '')
    left join {{ ref('stg_positions') }} as pos1
        on pos1.position = replace(p.second_position, '"', '')
)
select * from int_player