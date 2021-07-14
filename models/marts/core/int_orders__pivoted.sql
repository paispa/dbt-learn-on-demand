{%- set order_status = ['placed', 'shipped', 'completed', 'return_pending', 'returned'] -%}

with orders as (
    select * from {{ source ('jaffle_shop','orders') }}
),

pivoted as (

select  user_id,

{% for status in order_status -%}

SUM(case when status = '{{ status }}' then 1 else 0 end) AS {{ status }}_count
{%- if not loop.last -%}
,
{% endif -%}

{% endfor %}

from orders
group by 1
)

select * from pivoted