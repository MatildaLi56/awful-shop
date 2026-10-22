with

customer_history as (

    select

        *,
        created_at as changed_at

    from {{ ref('stg_customers') }}

),

-- today's values
customers as (

    select * from {{ ref('stg_customers') }}

),

locations as (

    select * from {{ ref('dim_location') }}

),

-- a customer's home store is where they placed their first order
first_orders as (

    select

        customer_id,
        location_id

    from {{ ref('stg_orders') }}
    where customer_id is not null
    qualify row_number() over (partition by customer_id order by ordered_at) = 1

),

versions as (

    select

        customer_history.*,
        customer_history.changed_at as valid_from,
        lead(customer_history.changed_at) over (
            partition by customer_history.customer_id
            order by customer_history.changed_at
        ) as next_changed_at

    from customer_history

),

customer_versions as (

    select

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['versions.customer_id', 'versions.valid_from']) }} as customer_key,
        versions.customer_id,
        coalesce(locations.location_id, '-1') as home_location_id,

        ---------- attributes
        customers.customer_name,
        coalesce(customers.phone, 'Unknown') as phone,
        coalesce(nullif(versions.email, ''), 'Unknown') as email,
        versions.city,
        coalesce(nullif(versions.state, ''), 'Unknown') as state,
        versions.country,
        case versions.loyalty_tier
            when 'B' then 'Bronze'
            when 'S' then 'Silver'
            when 'G' then 'Gold'
            when 'P' then 'Platinum'
        end as loyalty_tier,
        versions.is_marketing_opt_in,

        ---------- version dates
        -- a version runs from valid_from up to, but not including, valid_to
        versions.valid_from,
        coalesce(versions.next_changed_at, cast('9999-12-31' as timestamp)) as valid_to,
        versions.next_changed_at is null as is_current

    from versions

    inner join customers
        on versions.customer_id = customers.customer_id

    left join first_orders
        on versions.customer_id = first_orders.customer_id

    left join locations
        on first_orders.location_id = locations.location_id

),

-- facts point here when the order has no known customer:
-- 20 guest orders and 12 orders from customers not synced to the customer system
unknown_customer as (

    select

        '-1' as customer_key,
        null as customer_id,
        '-1' as home_location_id,
        'Unknown customer' as customer_name,
        'Unknown' as phone,
        'Unknown' as email,
        'Unknown' as city,
        'Unknown' as state,
        'Unknown' as country,
        'Unknown' as loyalty_tier,
        null as is_marketing_opt_in,
        cast('1900-01-01' as timestamp) as valid_from,
        cast('9999-12-31' as timestamp) as valid_to,
        true as is_current

),

final as (

    select * from customer_versions
    union all
    select * from unknown_customer

)

select * from final
