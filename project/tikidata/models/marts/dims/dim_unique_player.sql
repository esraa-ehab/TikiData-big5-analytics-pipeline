with dim_unique_player as (
    select 
        {{ dbt_utils.generate_surrogate_key(['player_id', 'player_name']) }} as  unique_player_sk,
        p.player_id,
        p.player_name,
        ic.country_name
        
    from {{ ref('int_unique_players') }} as p
    join {{ ref('int_countries') }} as ic
        on ic.country_id = p.country_id
)
select * from dim_unique_player