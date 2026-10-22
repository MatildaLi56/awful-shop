with

source as (

    select * from {{ source('ecom', 'raw_products') }}

),

renamed as (

    select

        ----------  ids
        sku as product_id,

        ---------- text
        name as product_name,
        type as product_type,
        description as product_description,
        department,
        category,
        subcategory,
        category_code,
        product_level,


        ---------- numerics
        {{ cents_to_dollars('price') }} as product_price,

        ---------- booleans
        coalesce(type = 'jaffle', false) as is_food_item,

        coalesce(type = 'beverage', false) as is_drink_item,

        is_active = 'Y' as is_active,

        ---------- timestamps
        launched_at as launched_date

    from source

)

select * from renamed
