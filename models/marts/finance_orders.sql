with

orders as (

    select * from {{ ref('fct_orders') }}

),

final as (

    select

        ----------  ids
        order_id,

        ---------- dimension keys
        date_key,
        location_id,

        ---------- measures, in dollars
        subtotal,
        tax_paid,
        delivery_fee,
        subtotal + tax_paid + delivery_fee as revenue

    from orders

)

select * from final
