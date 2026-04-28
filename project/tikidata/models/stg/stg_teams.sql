with stg_teams as (
    select 
        "Squad" as team_name,
        "League" as league_name
    from RAW.DBT_DEV_RAW_TABLES.TEAMS_TABLE
)
select * from stg_teams