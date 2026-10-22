with

regions as (

    select * from {{ ref('stg_regions') }}

),

sales_regions as (

    select

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['region_id']) }} as region_key,
        region_id,

        ---------- text
        region_name,
        division_name,
        country_code,
        regional_manager

    from regions

),

-- stores with no known region point here
unknown_region as (

    select

        '-1' as region_key,
        null as region_id,
        'Unknown' as region_name,
        'Unknown' as division_name,
        'Unknown' as country_code,
        'Unknown' as regional_manager

),

final as (

    select * from sales_regions
    union all
    select * from unknown_region

)

select * from final
