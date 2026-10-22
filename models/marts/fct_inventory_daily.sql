with

inventory as (

    select * from {{ ref('stg_inventory_daily') }}

),

locations as (

    select * from {{ ref('dim_location') }}

),

supplies as (

    select * from {{ ref('dim_supply') }}

),

final as (

    select

        ---------- dimension keys
        inventory.snapshot_date as date_key,
        locations.location_id,
        supplies.supply_key,

        ---------- measures
        -- levels at the end of the day: add them across stores and supplies,
        -- never across days (take the last day of the period instead)
        inventory.on_hand_qty,
        inventory.par_level,
        round(100.0 * inventory.on_hand_qty / nullif(inventory.par_level, 0), 1) as fill_rate_pct

    from inventory

    left join locations
        on inventory.location_id = locations.location_id

    left join supplies
        on inventory.supply_id = supplies.supply_id

)

select * from final
