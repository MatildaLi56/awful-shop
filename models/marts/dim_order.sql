with

orders as (

    select * from {{ ref('stg_orders') }}

),

statuses as (

    select distinct order_status_code, order_status from {{ ref('dim_order_profile') }}

),

final as (

    select

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['orders.order_id']) }} as order_key,
        orders.order_id,

        ---------- text
        statuses.order_status,
        orders.promo_code,

        ---------- timestamps
        orders.ordered_at

    from orders

    left join statuses
        on orders.order_status = statuses.order_status_code

)

select * from final
