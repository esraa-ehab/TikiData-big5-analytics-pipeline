with int_seasons as (
    select 
        *
    from {{ ref('stg_seasons') }}
)

select * from int_seasons