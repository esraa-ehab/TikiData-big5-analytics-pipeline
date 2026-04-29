with dim_formation as (
    select
        {{ dbt_utils.generate_surrogate_key(['formation_id', 'formation']) }}, 
        *
    from {{ ref('int_formations') }}
)

select * from dim_formation