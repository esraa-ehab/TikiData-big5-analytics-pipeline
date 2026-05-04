with dim_team as (
    select 
        {{ dbt_utils.generate_surrogate_key(['team_id', 'team_name'])}} as team_sk,
        t.team_id,
        t.team_name,
        lg.league_sk
        
    from {{ ref('int_teams') }} as t
    join {{ ref('dim_league') }} as lg
        on t.league_id = lg.league_id
)
select * from dim_team