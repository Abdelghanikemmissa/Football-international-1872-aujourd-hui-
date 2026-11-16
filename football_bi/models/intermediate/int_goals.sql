with goals as (
    select * from {{ ref('stg_goalscorers') }}
),
mapping as (
    select former_name as old_name, current_name as new_name 
    from {{ ref('stg_former_names') }}
    union 
    select former, current from {{ ref('former_extra') }}
),
normalized as (
    select
        g.match_date, coalesce(mh.new_name, g.home_team) as home_team,
        coalesce(ma.new_name, g.away_team) as away_team, g.is_penalty, g.is_own_goal
    from goals g
    left join mapping mh on g.home_team = mh.old_name
    left join mapping ma on g.away_team = ma.old_name
)
select m.match_key, n.is_penalty, n.is_own_goal
from normalized n
inner join {{ ref('int_matches') }} m
    on n.match_date = m.match_date and n.home_team = m.home_team and n.away_team = m.away_team