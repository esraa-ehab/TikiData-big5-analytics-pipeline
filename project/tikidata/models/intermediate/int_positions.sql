with int_positions as (
    select * from {{ ref('stg_positions') }}
)

select * from int_positions