with cleaned as (
    select *
    from (
        select
            *,
            row_number() over (
                partition by player_id, season
                order by annual_wage_eur desc nulls last
            ) as rn
        from {{ ref('int_players') }}
    )
    where rn = 1
),
base_data as (
    select
        *,
        lag(team_id) over (partition by player_id order by season) as prev_team_id,
        lag(annual_wage_eur) over (partition by player_id order by season) as prev_wage
    from cleaned
),
change_events as (
    select 
        *,
        case when 
            prev_team_id is null 
            or coalesce(team_id, 'N/A') != coalesce(prev_team_id, 'N/A')
            or (prev_wage is not null and abs(annual_wage_eur - prev_wage) / nullif(prev_wage, 0) > 0.025)
        then 1 else 0 end as is_change
    from base_data
),
final_timeline as (
    select
        *,
        lead(season) over (partition by player_id order by season) as next_change_season
    from change_events
    where is_change = 1
),
joined as (
select
    {{ dbt_utils.generate_surrogate_key(['ft.player_id', 'ft.team_id', 'ft.season']) }} as player_sk,
    ft.player_id,
    dt.team_sk,
    dp.position_full_form as main_position,
    ds.position_full_form as second_position,
    dl.league_sk,
    unqp.player_name,
    dc.country_name as nationality,
    player_age as start_age,
    coalesce(next_change_season - 1, (select max(season) from cleaned)) - birth_year as end_age,
    season as start_season,
    coalesce(next_change_season - 1, (select max(season) from cleaned)) as end_season,
    next_change_season,
    next_change_season is null as is_current
from final_timeline ft
left join {{ ref('dim_team') }} dt on dt.team_id = ft.team_id
left join {{ ref('int_positions') }} dp on ft.main_position_id = dp.position_id
left join {{ ref('int_positions') }} ds  on ft.second_position_id = ds.position_id 
left join {{ ref('int_countries') }} dc  on ft.country_id = dc.country_id
left join {{ ref('dim_league') }} dl on dl.league_id = ft.league_id
left join {{ ref('int_unique_players' )}} unqp on ft.player_id = unqp.player_id
)
select * from joined