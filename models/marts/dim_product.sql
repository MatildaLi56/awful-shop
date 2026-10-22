with

products as (

    select * from {{ ref('stg_products') }}

),

product_tags as (

    select * from {{ ref('stg_product_tags') }}

),

final as (

    select

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['products.product_id']) }} as product_key,
        products.product_id,

        ---------- text
        product_name,
        product_type,
        product_description,

        ---------- product hierarchy, flattened into the product row
        department,
        category,
        subcategory,
        coalesce(
            case category_code
                when 'F-SWT' then 'Food - sweet jaffle'
                when 'F-SAV' then 'Food - savoury jaffle'
                when 'B-CF' then 'Beverage - coffee'
                when 'B-TEA' then 'Beverage - tea'
                when 'B-SMO' then 'Beverage - smoothie'
                when 'B-JCE' then 'Beverage - juice'
            end,
            'All products'
        ) as category_description,
        product_tags.product_tag,

        ---------- booleans
        is_food_item,
        is_drink_item,
        is_active,

        ---------- dates
        launched_date

    from products

    left join product_tags
        on products.product_id = product_tags.product_id

)

select * from final
