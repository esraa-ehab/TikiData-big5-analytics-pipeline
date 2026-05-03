with stg_countries as(
    select "Nation_codes" as country_id,
           "Nation" as country_name
    from {{ source('RAW', 'raw_countries') }}
)
select * from stg_countries