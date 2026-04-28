with stg_teams as (
    select 
        "Squad" as team_name,
        "League" as league_name
    from {{ source('RAW', 'raw_teams') }}
)
select * from stg_teams