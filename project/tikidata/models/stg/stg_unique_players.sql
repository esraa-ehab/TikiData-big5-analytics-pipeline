with stg_unique_players as (
    select distinct "Player" as player_name, "Nation" as nation_id
    from {{ source('RAW', 'raw_players') }}
)

select concat('p', row_number() over(order by player_name)) as player_id,* from stg_unique_players