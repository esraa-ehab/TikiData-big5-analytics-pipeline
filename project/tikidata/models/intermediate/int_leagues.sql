with int_leagues as (select 
    l.league_id,
    l.league_name,
    c.country_id
from {{ ref('stg_leagues') }} l
    join {{ ref('stg_countries') }} c
    on c.country_name = l.country
)

select * from int_leagues