with stg_region as (
    select
        case 
            when "region" = 'Asia'       then 'AS'
            when "region" = 'Europe'     then 'EU'
            when "region" = 'Africa'     then 'AF'
            when "region" = 'Oceania'    then 'OC'
            when "region" = 'Americas'   then 'AM'
            when "region" = 'Antarctica' then 'AN'
            else 'Unknown' 
        end as region_iso_code,
        "region" as region_name
    from RAW.DBT_DEV_RAW_TABLES.REGIONS
)

select * 
from stg_region;