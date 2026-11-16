with v as (select distinct country, city from {{ ref('int_matches') }})
select row_number() over (order by country, city) as venue_key, country, city from v