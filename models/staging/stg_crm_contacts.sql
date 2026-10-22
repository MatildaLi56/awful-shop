with

source as (

    select * from {{ source('ecom', 'raw_crm_contacts') }}

),

renamed as (

    select

        ----------  ids
        contact_id as crm_contact_id,
        pos_customer_ref as customer_id,

        ---------- text
        full_name,
        email_address as email,
        phone_number as phone,
        lifecycle_stage,
        home_store as home_location_name,

        ---------- booleans
        cast(marketing_opt_in as boolean) as is_marketing_opt_in,

        ---------- timestamps
        strptime(created_date, '%m/%d/%Y')::date as created_date

    from source

)

select * from renamed
