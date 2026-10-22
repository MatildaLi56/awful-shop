with

source as (

    select * from {{ source('ecom', 'raw_items') }}

),

renamed as (

    select

        ----------  ids
        id as order_item_id,
        order_id,
        sku as product_id,

        ---------- text
        product_name,

        ---------- numerics
        {{ cents_to_dollars('unit_price') }} as unit_price

    from source

)

select * from renamed
