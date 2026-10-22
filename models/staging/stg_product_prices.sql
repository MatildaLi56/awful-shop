with

source as (

    select * from {{ source('ecom', 'raw_product_prices') }}

),

renamed as (

    select

        ----------  ids
        sku as product_id,

        ---------- numerics
        {{ cents_to_dollars('price') }} as product_price,

        ---------- booleans
        is_current = 'Y' as is_current,

        ---------- timestamps
        valid_from,
        valid_to

    from source

)

select * from renamed
