with stg_season as (
    select "season_id", "season"
    from {{ source('raw', 'raw_seasons') }}
)
select * from stg_season