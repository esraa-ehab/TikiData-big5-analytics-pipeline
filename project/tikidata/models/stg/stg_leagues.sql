with stg_league as (
    select 
        "League_id" as league_id,
        "League_name" as league_name,
        "Country" as country,
        "Season_year" as season
    from RAW.DBT_DEV_RAW_TABLES.LEAGUE_TABLE
)
select * from stg_league