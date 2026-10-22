with

source as (

    select * from {{ source('ecom', 'raw_stores') }}

),

renamed as (

    select

        ----------  ids
        id as location_id,
        region_id,

        ---------- text
        name as location_name,
        city,
        state,
        store_type,
        manager_name,

        ---------- numerics
        tax_rate,
        square_feet,

        ---------- dates
        cast(opened_at as date) as opened_date,
        cast(closed_at as date) as closed_date

    from source

)

select * from renamed
