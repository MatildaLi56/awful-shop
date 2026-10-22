{{ config(materialized='table') }}

with

customers as (

    select * from {{ ref('stg_customers') }}

),

tier_periods as (

    select

        ----------  ids
        customer_id,

        ---------- text
        loyalty_tier,

        ---------- period dates
        -- a period runs from valid_from up to, but not including, valid_to
        updated_at as valid_from,
        coalesce(
            lead(updated_at) over (partition by customer_id order by updated_at),
            cast('9999-12-31' as timestamp)
        ) as valid_to,
        lead(updated_at) over (partition by customer_id order by updated_at) is null as is_current

    from customers

)

select * from tier_periods
