with

contacts as (

    select * from {{ ref('stg_crm_contacts') }}

),

final as (

    select

        ----------  ids
        crm_contact_id as contact_id,

        ---------- text
        full_name,
        email,
        phone,
        lifecycle_stage,
        home_location_name,

        ---------- booleans
        is_marketing_opt_in,

        ---------- dates
        created_date

    from contacts

)

select * from final
