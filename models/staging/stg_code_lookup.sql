with

source as (

    select * from {{ source('ecom', 'raw_code_lookup') }}

),

renamed as (

    select

        ---------- text
        code_type,
        code,
        description as code_description,

        ---------- numerics
        sort_order,

        ---------- booleans
        is_active = 'Y' as is_active

    from source

)

select * from renamed
