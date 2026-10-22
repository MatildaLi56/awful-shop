with

product_prices as (

    select * from {{ ref('stg_product_prices') }}

),

final as (

    select

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['product_id', 'valid_from']) }} as product_price_key,
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
        product_id,

        ---------- numerics
        product_price,

        ---------- dates
        -- a period runs from valid_from up to, but not including, valid_to
        valid_from,
        coalesce(valid_to, cast('9999-12-31' as date)) as valid_to,

        ---------- booleans
        is_current

    from product_prices

)

select * from final
