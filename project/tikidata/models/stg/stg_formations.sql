with stg_formations as (
    select 
        'f' || "a" as formation_id,
        "formations"
    from {{ source('raw', 'raw_formations') }}
)
select * from stg_formations