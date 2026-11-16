with bounds as (
    select min(match_date) as d_min, max(match_date) as d_max from {{ ref('int_matches') }}
),
spine as (
    select unnest(generate_series((select d_min from bounds), (select d_max from bounds), interval 1 day)) as full_date
)
select
    cast(strftime(full_date, '%Y%m%d') as integer) as date_key,
    cast(full_date as date) as full_date,
    extract(month from full_date) as mois_num,
    case extract(month from full_date)
        when 1 then 'janvier' when 2 then 'février' when 3 then 'mars' when 4 then 'avril'
        when 5 then 'mai' when 6 then 'juin' when 7 then 'juillet' when 8 then 'août'
        when 9 then 'septembre' when 10 then 'octobre' when 11 then 'novembre' when 12 then 'décembre'
    end as mois_nom,
    extract(quarter from full_date) as trimestre,
    extract(year from full_date) as annee,
    cast(floor(extract(year from full_date)/10)*10 as integer) as decennie,
    case when extract(year from full_date) < 1950 then '1900-1949'
         when extract(year from full_date) < 2000 then '1950-1999' else '2000+' end as epoque
from spine