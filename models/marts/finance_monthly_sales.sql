with

monthly_sales as (

    select * from {{ ref('stg_store_monthly_sales') }}

),

final as (

    select

        ---------- text
        location_name,

        ---------- numerics
        fiscal_year,
        jan_sales,
        feb_sales,
        mar_sales,
        apr_sales,
        may_sales,
        jun_sales,
        jul_sales,
        aug_sales,
        sep_sales,
        oct_sales,
        nov_sales,
        dec_sales,
        coalesce(jan_sales, 0) + coalesce(feb_sales, 0) + coalesce(mar_sales, 0)
            + coalesce(apr_sales, 0) + coalesce(may_sales, 0) + coalesce(jun_sales, 0)
            + coalesce(jul_sales, 0) + coalesce(aug_sales, 0) + coalesce(sep_sales, 0)
            + coalesce(oct_sales, 0) + coalesce(nov_sales, 0) + coalesce(dec_sales, 0)
            as annual_sales,
        ytd_sales,
        ytd_orders

    from monthly_sales

)

select * from final
