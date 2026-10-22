with

code_lookup as (

    select * from {{ ref('stg_code_lookup') }}

),

final as (

    select

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['code_type', 'code']) }} as code_key,
        code_type,
        code,

        ---------- text
        code_description,

        ---------- numerics
        sort_order,

        ---------- booleans
        is_active

    from code_lookup

)

select * from final
