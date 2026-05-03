with ordered as (
    select
        *,
        row_number() over (partition by player_id order by season) as rn,
        lead(player_age) over (partition by player_id order by season) as next_age,
        lead(season) over (partition by player_id order by season) as next_season,
    from DEV.DBT_DEV.INT_PLAYERS
), 
player_changes as (
    select 
        curr.*,
    from ordered as curr
    left join ordered as prev
        on curr.player_id = prev.player_id and curr.rn = prev.rn + 1
    where prev.player_id is null 
           OR curr.team_id        != prev.team_id
           OR curr.main_position_id     != prev.main_position_id
) 
select 
    player_id,
    team_id,
    main_position_id,
    second_position_id,
    player_age as start_age,
    next_age as end_age,
    season,
    next_season is null as is_current
from player_changes
order by player_id, season