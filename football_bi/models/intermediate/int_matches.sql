with src as (
    select * from {{ ref('stg_results') }}
),
mapping as (
    select former_name as old_name, current_name as new_name 
    from {{ ref('stg_former_names') }}
    union
    select former, current from {{ ref('former_extra') }}
),
normalized as (
    select
        r.match_date,
        coalesce(mh.new_name, r.home_team) as home_team,
        coalesce(ma.new_name, r.away_team) as away_team,
        r.home_score, r.away_score, r.tournament, r.city, r.country, r.is_neutral
    from src r
    left join mapping mh on r.home_team = mh.old_name
    left join mapping ma on r.away_team = ma.old_name
),
numbered as (
    select *, row_number() over (partition by match_date, home_team, away_team order by match_date) as match_seq
    from normalized
)
select
    md5(cast(match_date as varchar) || '|' || home_team || '|' || away_team || '|' || cast(match_seq as varchar)) as match_key,
    match_date, home_team, away_team, home_score, away_score,
    home_score + away_score as total_goals,
    home_score - away_score as goal_diff,
    case when home_score > away_score then 1 else 0 end as is_home_win,
    case when home_score = away_score then 1 else 0 end as is_draw,
    case when home_score < away_score then 1 else 0 end as is_away_win,
    tournament, city, country, is_neutral
from numbered