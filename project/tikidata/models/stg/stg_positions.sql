with stg_positions as (
    select distinct replace(main_position, '"', '') as position
    from {{ ref("stg_players") }}
    where position is not null
)

select * from stg_positions