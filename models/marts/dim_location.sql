with

locations as (

    select * from {{ ref('stg_locations') }}

),

stores as (

    select

        ----------  ids
        locations.location_id,
        {{ dbt_utils.generate_surrogate_key(['locations.region_id']) }} as region_key,

        ---------- text
        locations.location_name,
        locations.city,
        locations.state,
        locations.store_type,
        locations.manager_name,

        ---------- numerics
        locations.tax_rate,
        locations.square_feet,

        ---------- dates
        locations.opened_date,
        locations.closed_date,

        ---------- booleans
        locations.closed_date is null as is_open

    from locations

),

-- facts point here when the source has no store (8 orders)
unknown_store as (

    select

        '-1' as location_id,
        '-1' as region_key,
        'Unknown store' as location_name,
        'Unknown' as city,
        'Unknown' as state,
        'Unknown' as store_type,
        'Unknown' as manager_name,
        null as tax_rate,
        null as square_feet,
        null as opened_date,
        null as closed_date,
        null as is_open

),

final as (

    select * from stores
    union all
    select * from unknown_store

)

select * from final
