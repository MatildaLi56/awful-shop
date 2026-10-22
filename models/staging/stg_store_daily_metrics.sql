with

source as (

    select * from {{ source('ecom', 'raw_store_daily_metrics') }}

),

renamed as (

    select

        ----------  ids
        store_id as location_id,

        ---------- text
        metric_name,

        ---------- numerics
        metric_value,

        ---------- timestamps
        strptime(cast(metric_date as varchar), '%Y%m%d')::date as metric_date

    from source

)

select * from renamed
