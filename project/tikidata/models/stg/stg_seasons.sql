with stg_season as (
    select "season_id", "season"
    from RAW.DBT_DEV_RAW_TABLES.SEASONS_TABLE
)
select * from stg_season