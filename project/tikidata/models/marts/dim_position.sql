with dim_position as (
    select 
        {{ dbt_utils.generate_surrogate_key(['position_id', 'position']) }} as position_sk,
        position_id,
        position,
        position_full_form
    from {{ ref('int_positions') }}
)
select * from dim_position