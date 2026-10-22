with

statuses as (

    select * from (
        values ('C', 'Completed'), ('R', 'Refunded'), ('X', 'Cancelled')
    ) as statuses (order_status_code, order_status)

),

channels as (

    select * from (
        values ('I', 'In store'), ('O', 'Online pickup'), ('D', 'Delivery')
    ) as channels (order_channel_code, order_channel)

),

promo_flags as (

    select * from (values (true), (false)) as promo_flags (has_promo)

),

-- every possible combination, so a new combination in the data still finds its row
final as (

    select

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['order_status_code', 'order_channel_code', 'has_promo']) }} as order_profile_key,

        ---------- text
        order_status_code,
        order_status,
        order_channel_code,
        order_channel,

        ---------- booleans
        has_promo

    from statuses
    cross join channels
    cross join promo_flags

)

select * from final
