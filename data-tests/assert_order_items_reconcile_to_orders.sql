{{ config(severity='warn') }}

-- The items of an order must add up to the order's subtotal.
-- Returns every order where they don't; the test passes when no rows come back.
-- Orders with no items (cancelled before anything was added) must have a subtotal of 0.

with

item_totals as (

    select
        order_id,
        sum(item_amount) as item_amount
    from {{ ref('fct_order_items') }}
    group by order_id

)

select

    orders.order_id,
    orders.subtotal,
    coalesce(item_totals.item_amount, 0) as item_amount

from {{ ref('fct_orders') }} as orders

left join item_totals
    on orders.order_id = item_totals.order_id

where orders.subtotal <> coalesce(item_totals.item_amount, 0)
