select 
    ip.player_id,
    '' as player_sk,
    ip.season,
    ip.weekly_wage_usd,
    ip.weekly_wage_eur,
    ip.weekly_wage_gbp,
from DEV.DBT_DEV.INT_PLAYERS as ip
join PROD.DBT_DEV_MARTS.DIM_PLAYER as dp
    on ip.player_id = dp.player_id
    and ip.player_age >= dp.start_age
    and (ip.player_age < dp.end_age OR dp.end_age IS NULL)
    and ip.season = dp.season