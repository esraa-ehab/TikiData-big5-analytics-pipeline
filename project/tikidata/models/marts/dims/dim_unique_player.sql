with dim_unique_player as (
    select 
        {{ dbt_utils.generate_surrogate_key(['player_id', 'player_name']) }} as player_sk,
        p.player_id,
        p.player_name,
        dc.country_sk
        
    from {{ ref('int_unique_players') }} as p
    join {{ ref('dim_country') }} as dc
        on dc.country_id = p.country_id
)
select * from dim_unique_player