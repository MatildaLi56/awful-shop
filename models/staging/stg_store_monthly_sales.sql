with

source as (

    select * from {{ source('ecom', 'raw_store_monthly_sales') }}

),

renamed as (

    select

        ---------- text
        store_name as location_name,

        ---------- numerics
        fiscal_year,
        -- the finance sheet is already in dollars, so no cents_to_dollars here
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
        ytd_sales,
        ytd_orders,

        ---------- timestamps
        last_refreshed as last_refreshed_date

    from source

)

select * from renamed
