with dim_season as (
    select 
        {{ dbt_utils.generate_surrogate_key(['season_id', 'season']) }} as season_sk,
        season_id,
        season
    from {{ ref('int_seasons') }}
)
select * from dim_season