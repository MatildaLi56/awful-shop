with

source as (

    select * from {{ source('ecom', 'raw_regions') }}

),

renamed as (

    select

        ----------  ids
        region_id,

        ---------- text
        region_name,
        division_name,
        country_code,
        regional_manager

    from source

)

select * from renamed
