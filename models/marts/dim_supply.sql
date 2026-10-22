with

supplies as (

    select * from {{ ref('stg_supplies') }}

),

-- stg_supplies repeats each supply once per product that uses it,
-- with the same name, cost and perishable flag on every copy
final as (

    select distinct

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['supply_id']) }} as supply_key,
        supply_id,

        ---------- text
        supply_name,

        ---------- numerics
        supply_cost,

        ---------- booleans
        is_perishable_supply

    from supplies

)

select * from final
