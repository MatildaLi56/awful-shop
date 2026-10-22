with

source as (

    select * from {{ source('ecom', 'raw_payments') }}

),

renamed as (

    select

        ----------  ids
        id as payment_id,
        order_id,

        ---------- text
        payment_method,
        payment_status,

        ---------- numerics
        {{ cents_to_dollars('amount') }} as amount,

        ---------- timestamps
        created_at

    from source

)

select * from renamed
