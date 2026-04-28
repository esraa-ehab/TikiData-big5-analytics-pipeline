with stg_teams as (
    select 
        "Squad" as team_name,
        "League" as league_name
    from {{ source('raw', 'raw_teams') }}
)
select * from stg_teams