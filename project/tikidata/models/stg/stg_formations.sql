with stg_formations as (
    select 
        'f' || "a" as formation_id,
        "formations"
    from RAW.DBT_DEV_RAW_TABLES.FORMATIONS_TABLE
)
select * from stg_formations