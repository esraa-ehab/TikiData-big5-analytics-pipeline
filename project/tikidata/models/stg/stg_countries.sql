with stg_countries as(
    select "ID" as country_id,
           "ISO 3166-1 Alpha 3-Codes" as country_iso_codes,
           "Preferred Term" as preferred_term,
           "Latitude" as latitude,
           "Longitude" as longitude,
           "Region Name" as region_name
    from {{ source('raw','raw_countries') }}
)
select * from stg_countries