with dim_league as (select 
    {{ dbt_utils.generate_surrogate_key(['league_id', 'league_name']) }} as league_sk,
    league_id,
    league_name,
    c.country_sk
from
    {{ ref('int_leagues') }} l
    join {{ ref('dim_country') }} c
        on c.country_id = l.country_id
)

select * from dim_league