with

payments as (

    select * from {{ ref('stg_payments') }}

),

payment_methods as (

    select * from {{ ref('dim_code') }}

),

-- the store comes from the order, so payments can be compared with orders by store
orders as (

    select * from {{ ref('fct_orders') }}

),

final as (

    select

        ----------  ids
        payments.payment_id,
        payments.order_id,

        ---------- dimension keys
        cast(strftime(payments.created_at, '%Y%m%d') as integer) as payment_date,
        payment_methods.code_key as payment_method_key,
        orders.location_id,

        ---------- text
        payments.payment_status,

        ---------- measures, in dollars
        -- refunds are negative, so summing all rows gives the net amount received
        payments.amount,

        ---------- timestamps
        payments.created_at

    from payments

    left join payment_methods
        on payments.payment_method = payment_methods.code
        and payment_methods.code_type = 'PAYMENT_METHOD'

    inner join orders
        on payments.order_id = orders.order_id

)

select * from final
