with

store_metrics as (

    select * from {{ ref('stg_store_daily_metrics') }}

),

locations as (

    select * from {{ ref('dim_location') }}

),

-- the feed has one row per store, day and metric; turn it into one row per store and day
pivoted as (

    select

        location_id,
        metric_date,
        max(case when metric_name = 'gross_sales' then metric_value end) as gross_sales,
        max(case when metric_name = 'order_count' then metric_value end) as order_count,
        max(case when metric_name = 'foot_traffic' then metric_value end) as foot_traffic,
        max(case when metric_name = 'avg_wait_minutes' then metric_value end) as avg_wait_minutes

        -- conversion_rate is order_count / foot_traffic, a ratio, so it is not stored;
        -- it is defined as the conversion_rate metric

    from store_metrics
    group by location_id, metric_date

),

final as (

    select

        ---------- dimension keys
        pivoted.metric_date as date_key,
        locations.location_id,

        ---------- measures
        cast(pivoted.gross_sales as decimal(16, 2)) as gross_sales,
        cast(pivoted.order_count as integer) as order_count,
        cast(pivoted.foot_traffic as integer) as foot_traffic,
        pivoted.avg_wait_minutes

    from pivoted

    left join locations
        on pivoted.location_id = locations.location_id

)

select * from final
