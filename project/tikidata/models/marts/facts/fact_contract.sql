with fact_contracts as (
    select 
        ip.player_id,
        '' as player_sk, 
        ip.season,
        ip.team_id,
        ip.main_position_id,
        ip.second_position_id,
        ip.annual_wage_eur,
        ip.annual_wage_usd,
        ip.annual_wage_gbp
    from {{ ref('int_players') }} as ip
    join {{ ref('dim_player') }} as dp
        on ip.player_id = dp.player_id
        and ip.season >= dp.start_season
        and ip.season <= dp.end_season
)
select * 
from fact_contracts
order by player_id, season