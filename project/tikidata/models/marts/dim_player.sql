with dim_player as (
    select 
        {{ dbt_utils.generate_surrogate_key(['player_id', 'player_name']) }} as player_sk,
        p.player_id,
        p.player_name,
        dc.country_sk
        
    from DEV.DBT_DEV.INT_UNIQUE_PLAYERS as p
    join PROD.DBT_DEV_MARTS.DIM_COUNTRY as dc
        on dc.country_id = p.country_id
)
select * from dim_player