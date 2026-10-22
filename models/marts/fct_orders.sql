{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'append',
        on_schema_change = 'append_new_columns'
    )
}}

with

orders as (

    select

        id as order_id,
        store_id as location_id,
        customer as customer_id,
        status as order_status,
        channel as order_channel,
        promo_code,
        (subtotal / 100)::numeric(16, 2) as subtotal,
        (tax_paid / 100)::numeric(16, 2) as tax_paid,
        (order_total / 100)::numeric(16, 2) as order_total,
        (delivery_fee / 100)::numeric(16, 2) as delivery_fee,
        ordered_at,
        updated_at,
        cast(ordered_at as date) as ordered_date

    from {{ source('ecom', 'raw_orders') }}

    {% if is_incremental() %}
    where ordered_at > (select max(ordered_at) from {{ this }})
    {% endif %}

),

customers as (

    select * from {{ ref('dim_customer') }}

),

locations as (

    select * from {{ ref('dim_location') }}

),

order_flags as (

    select

        orders.*,
        orders.promo_code is not null as has_promo

    from orders

),

final as (

    select

        ----------  ids
        order_flags.order_id,

        ---------- dimension keys
        order_flags.ordered_date as date_key,
        coalesce(locations.location_id, '-1') as location_id,
        coalesce(customers.customer_key, '-1') as customer_key,
        {{ dbt_utils.generate_surrogate_key(['order_flags.order_status', 'order_flags.order_channel', 'order_flags.has_promo']) }} as order_profile_key,

        ---------- measures, in dollars
        order_flags.subtotal,
        order_flags.tax_paid,
        order_flags.delivery_fee,
        order_flags.order_total,
        order_flags.subtotal + order_flags.tax_paid as revenue,

        ---------- timestamps
        order_flags.ordered_at,
        order_flags.updated_at

    from order_flags

    left join locations
        on order_flags.location_id = locations.location_id

    -- the customer version that was true when the order was placed
    left join customers
        on order_flags.customer_id = customers.customer_id
        and order_flags.ordered_at >= customers.valid_from
        and order_flags.ordered_at < customers.valid_to

)

select * from final
