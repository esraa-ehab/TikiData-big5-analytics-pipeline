with int_player as (
    select 
        p.player_stats_id,
        up.player_id,
        p.rank,
        lg.league_id,
        p.country_id,
        replace(p.main_position, '"', '') as main_position,
        replace(p.second_position, '"', '') as second_position,
        tm.team_id,
        p.birth_year,
        to_number(replace(regexp_substr(p.weekly_wages, '£\\s*([0-9,]+)', 1, 1, 'e', 1), ',', '')) as weekly_wage_gbp,
        to_number(replace(regexp_substr(p.weekly_wages, '€\\s*([0-9,]+)', 1, 1, 'e', 1), ',', '')) as weekly_wage_eur,
        to_number(replace(regexp_substr(p.weekly_wages, '\\$\\s*([0-9,]+)', 1, 1, 'e', 1), ',', '')) as weekly_wage_usd,
        szn."season_id" 
        
    from DEV.DBT_DEV.STG_PLAYERS as p
    join DEV.DBT_DEV.STG_UNIQUE_PLAYERS as up
        on p.player_name = up.player_name
    join DEV.DBT_DEV.STG_TEAMS as tm
        on p.team_name = tm.team_name
    join DEV.DBT_DEV.STG_LEAGUES as lg
        on tm.league_name = lg.league_name
    join DEV.DBT_DEV.STG_SEASONS as szn
        on p.season_id = szn."season"
)
select * from int_player