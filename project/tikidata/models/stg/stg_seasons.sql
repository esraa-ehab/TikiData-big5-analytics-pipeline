with stg_season as (
    select "season_id" as season_id, "season" as season  
    from {{ source('RAW', 'raw_seasons') }}
)
select * from stg_season