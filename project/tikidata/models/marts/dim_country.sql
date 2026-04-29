with dim_countries as (
    select
        {{ dbt_utils.generate_surrogate_key(['country_id']) }} as country_sk,
        *
    from
        {{ ref('int_countries') }}
)

select * from dim_countries