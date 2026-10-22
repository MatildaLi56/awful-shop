with

source as (

    select * from {{ source('ecom', 'raw_orders') }}

),

renamed as (

    select

        ----------  ids
        id as order_id,
        store_id as location_id,
        customer as customer_id,

        ---------- text
        status as order_status,
        channel as order_channel,
        promo_code,

        ---------- numerics
        subtotal as subtotal_cents,
        tax_paid as tax_paid_cents,
        order_total as order_total_cents,
        delivery_fee as delivery_fee_cents,
        {{ cents_to_dollars('subtotal') }} as subtotal,
        {{ cents_to_dollars('tax_paid') }} as tax_paid,
        {{ cents_to_dollars('order_total') }} as order_total,
        {{ cents_to_dollars('delivery_fee') }} as delivery_fee,

        ---------- timestamps
        ordered_at,
        updated_at,

        ---------- dates
        cast(ordered_at as date) as ordered_date

    from source

)

select * from renamed
