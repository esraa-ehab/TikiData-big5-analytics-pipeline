with int_teams as (
    select 
        tm.team_id,
        tm.team_name,
        lg.league_id
    from {{ ref(STG_TEAMS) }} as tm
    join {{ ref(STG_LEAGUES) }} as lg
        on tm.league_name = lg.league_name
)
select * from int_teams