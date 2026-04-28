with int_unique_players as (
    select 
        player_id,
        player_name,
        nation_id as country_id
    from {{ ref('stg_unique_players') }}
)

select * from int_unique_players