with stg_teams as (
    select 
        concat('t', ROW_NUMBER() over(order by "Squad")) as team_id,
        "Squad" as team_name,
        "League" as league_name
    from {{ source('RAW', 'raw_teams') }}
)
select * from stg_teams