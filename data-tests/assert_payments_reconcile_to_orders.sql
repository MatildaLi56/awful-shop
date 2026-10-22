-- The successful payments of an order must add up to what the customer was asked to pay:
-- order_total (subtotal + tax) plus the delivery fee.
-- Returns every order where they don't; the test passes when no rows come back.
-- Cancelled orders have no payments and a total of 0.

with

payment_totals as (

    select
        order_id,
        sum(amount) as paid_amount
    from {{ ref('fct_payments') }}
    where payment_status = 'success'
    group by order_id

)

select

    orders.order_id,
    orders.order_total + orders.delivery_fee as amount_due,
    coalesce(payment_totals.paid_amount, 0) as paid_amount

from {{ ref('fct_orders') }} as orders

left join payment_totals
    on orders.order_id = payment_totals.order_id

where orders.order_total + orders.delivery_fee <> coalesce(payment_totals.paid_amount, 0)
