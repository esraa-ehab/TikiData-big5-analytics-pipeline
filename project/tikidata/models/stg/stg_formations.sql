with stg_formations as (
    select 
        'f' || row_number() over (order by "formations") as formation_id,
        "formations" as formation
    from {{ source('RAW','raw_formations') }}
)

select * from stg_formations