{{
  config(
    materialized = 'view'
    )
}}

with stg_positions as (
    select distinct replace(main_position, '"', '') as position
    from {{ ref('stg_players') }}
    where main_position is not null
)

select 
    concat('pos', row_number() over (order by position)) as position_id,
    position,
    case position
        when 'AM' then 'Attacking Midfielder'
        when 'CB' then 'Centre Back'
        when 'CF' then 'Centre Forward'
        when 'CM' then 'Central Midfielder'
        when 'DF' then 'Defender'
        when 'DM' then 'Defensive Midfielder'
        when 'FW' then 'Forward'
        when 'GK' then 'Goalkeeper'
        when 'LB' then 'Left Back'
        when 'LM' then 'Left Midfielder'
        when 'LW' then 'Left Winger'
        when 'MF' then 'Midfielder'
        when 'RB' then 'Right Back'
        when 'RM' then 'Right Midfielder'
        when 'RW' then 'Right Winger'
        when 'SS' then 'Second Striker'
        else 'Unknown'
    end as position_full_form
from stg_positions