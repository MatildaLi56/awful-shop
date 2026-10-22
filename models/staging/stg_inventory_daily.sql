with

source as (

    select * from {{ source('ecom', 'raw_inventory_daily') }}

),

renamed as (

    select

        ----------  ids
        store_id as location_id,
        supply_id,

        ---------- text
        supply_name,

        ---------- numerics
        on_hand_qty,
        par_level,
        {{ cents_to_dollars('unit_cost') }} as unit_cost,
        {{ cents_to_dollars('stock_value') }} as stock_value,
        fill_rate_pct,

        ---------- timestamps
        snapshot_date

    from source

)

select * from renamed
