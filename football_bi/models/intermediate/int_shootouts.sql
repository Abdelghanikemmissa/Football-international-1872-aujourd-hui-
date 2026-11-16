with so as (
    select * from {{ ref('stg_shootouts') }}
),
mapping as (
    select former_name as old_name, current_name as new_name 
    from {{ ref('stg_former_names') }}
    union 
    select former, current from {{ ref('former_extra') }}
),
normalized as (
    select
        s.match_date, coalesce(mh.new_name, s.home_team) as home_team,
        coalesce(ma.new_name, s.away_team) as away_team, coalesce(mw.new_name, s.winner) as winner
    from so s
    left join mapping mh on s.home_team = mh.old_name
    left join mapping ma on s.away_team = ma.old_name
    left join mapping mw on s.winner = mw.old_name
)
select m.match_key, n.winner
from normalized n
inner join {{ ref('int_matches') }} m
    on n.match_date = m.match_date and n.home_team = m.home_team and n.away_team = m.away_team