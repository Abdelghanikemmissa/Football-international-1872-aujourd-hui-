with tournois as (
    select distinct tournament from {{ ref('int_matches') }}
),
cat as (
    select tournament, category, cast(is_official as integer) as is_official from {{ ref('tournament_category') }}
)
select
    row_number() over (order by t.tournament) as tournament_key,
    t.tournament,
    coalesce(c.category, 'Autre') as category,
    coalesce(c.is_official, 0) as is_official
from tournois t left join cat c on t.tournament = c.tournament