with int_formations as (
    select 
        *
    from {{ ref('stg_formations') }}
)

select * from int_formations