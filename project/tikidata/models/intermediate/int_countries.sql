with int_countries as (
    select 
        *
    from {{ ref('stg_countries') }}
)

select * from int_countries