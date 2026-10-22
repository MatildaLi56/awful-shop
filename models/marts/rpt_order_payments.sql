with

orders as (

    select * from {{ ref('fct_orders') }}

),

payments as (

    select * from {{ ref('fct_payments') }}

),

final as (

    select

        ---------- dimension keys
        orders.date_key,

        ---------- measures, in dollars
        sum(orders.order_total) as order_total,
        sum(payments.amount) as payment_amount

    from orders

    inner join payments
        on orders.order_id = payments.order_id

    group by orders.date_key

)

select * from final
