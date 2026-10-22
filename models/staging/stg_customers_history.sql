with

source as (

    select * from {{ source('ecom', 'raw_customers_history') }}

),

renamed as (

    select

        ----------  ids
        customer_id,

        ---------- text
        name as customer_name,
        email,
        phone,
        city,
        state,
        case
            when country in ('US', 'USA', 'United States') then 'US'
            else country
        end as country,
        loyalty_tier,
        operation as change_operation,

        ---------- booleans
        marketing_opt_in = 'Y' as is_marketing_opt_in,

        ---------- timestamps
        changed_at

    from source

)

select * from renamed
