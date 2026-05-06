with base as (
    select
        ip.player_id,
        ip.team_id,
        ip.season,
        ip.main_position_id,
        ip.second_position_id,
        ip.annual_wage_eur,
        ip.annual_wage_usd,
        ip.annual_wage_gbp
    from {{ ref('int_players') }} as ip
),
joined as (
    select
        {{ dbt_utils.generate_surrogate_key(['b.player_id', 'b.team_id', 'b.season']) }} as contract_sk,
        dpl.player_sk,
        dt.team_sk,
        b.season,
        dp.position_sk as main_position_sk,
        ds.position_sk as second_position_sk,
        b.annual_wage_eur,
        b.annual_wage_usd,
        b.annual_wage_gbp
    from base b
    join {{ ref('dim_player') }} dpl on b.player_id = dpl.player_id
                                        and b.season >= dpl.start_season
                                        and b.season <= dpl.end_season
    left join {{ ref('dim_team') }} dt on b.team_id = dt.team_id
    left join {{ ref('dim_position') }} dp   on b.main_position_id = dp.position_id
    left join {{ ref('dim_position') }} ds   on b.second_position_id = ds.position_id
)
select * from joined