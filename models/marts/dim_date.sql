with

days as (

    {{
        dbt_utils.date_spine(
            datepart = 'day',
            start_date = "cast('2023-01-01' as date)",
            end_date = "cast('2027-01-01' as date)"
        )
    }}

),

final as (

    select

        ----------  ids
        cast(date_day as date) as date_day,

        ---------- calendar
        extract(year from date_day) as year_number,
        extract(quarter from date_day) as quarter_number,
        extract(month from date_day) as month_number,
        monthname(date_day) as month_name,
        cast(date_trunc('month', date_day) as date) as month_start_date,
        extract(day from date_day) as day_of_month,
        extract(isodow from date_day) as day_of_week,
        dayname(date_day) as day_name,

        ---------- booleans
        extract(isodow from date_day) in (6, 7) as is_weekend

    from days

)

select * from final
