with

order_items as (

    select * from {{ ref('stg_order_items') }}

),

-- order-level keys come from fct_orders, so both facts always agree
orders as (

    select * from {{ ref('fct_orders') }}

),

products as (

    select distinct product_id, product_key, product_name from {{ ref('dim_product') }}

),

current_prices as (

    select product_id, product_price from {{ ref('dim_product_price') }}
    where is_current

),

order_profiles as (

    select * from {{ ref('dim_order_profile') }}

),

order_details as (

    select order_id, customer_id, promo_code from {{ ref('stg_orders') }}

),

final as (

    select

        ----------  ids
        order_items.order_item_id,
        order_items.order_id,
        {{ dbt_utils.generate_surrogate_key(['order_items.order_id']) }} as order_key,

        ---------- dimension keys
        orders.date_key,
        products.product_key,
        orders.location_id,
        case
            when orders.customer_key = '-1' and order_details.customer_id is not null
                then order_details.customer_id
            else orders.customer_key
        end as customer_key,
        orders.order_profile_key,

        ---------- text
        products.product_name,
        order_profiles.order_channel,
        order_profiles.order_status,
        order_details.promo_code,

        ---------- measures, in dollars
        current_prices.product_price as item_amount,
        current_prices.product_price as revenue,
        orders.delivery_fee,
        orders.tax_paid,
        orders.order_total

    from order_items

    inner join orders
        on order_items.order_id = orders.order_id

    left join products
        on order_items.product_id = products.product_id

    left join current_prices
        on order_items.product_id = current_prices.product_id

    left join order_profiles
        on orders.order_profile_key = order_profiles.order_profile_key

    left join order_details
        on order_items.order_id = order_details.order_id

)

select * from final
