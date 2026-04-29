with dim_countries as (
    select
        row_number() over(order by country_id) as country_sk,
        *
    from
        {{ ref('int_countries') }}
)

select * from dim_countries