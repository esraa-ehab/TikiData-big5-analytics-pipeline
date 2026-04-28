with int_seasons as (
    select 
        *
    from {{ source('stg_seasons') }}
)

select * from int_seasons