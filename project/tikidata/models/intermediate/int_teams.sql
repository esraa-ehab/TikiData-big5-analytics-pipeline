with int_teams as (
    select 
        tm.team_id,
        tm.team_name,
        lg.league_id
    from {{ ref('stg_teams') }} as tm
    join {{ ref('stg_leagues') }} as lg
        on tm.league_name = lg.league_name
)
select * from int_teams