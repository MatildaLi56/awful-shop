with

inventory as (

    select * from {{ ref('fct_inventory_daily') }}

),

final as (

    select

        ---------- dimension keys
        date_trunc('month', inventory.date_key) as month_start_date,
        inventory.location_id,
        inventory.supply_key,

        ---------- measures
        sum(inventory.on_hand_qty) as on_hand_qty,
        sum(inventory.par_level) as par_level

    from inventory

    group by 1, 2, 3

)

select * from final
