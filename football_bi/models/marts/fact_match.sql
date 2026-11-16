with base as (select * from {{ ref('int_matches') }}),
keys as (
    select
        b.match_key, d.date_key, th.team_key as home_team_key, ta.team_key as away_team_key,
        tn.tournament_key, v.venue_key, b.home_score, b.away_score, b.total_goals, b.goal_diff,
        b.is_home_win, b.is_draw, b.is_away_win, cast(b.is_neutral as integer) as is_neutral
    from base b
    left join {{ ref('dim_date') }} d on b.match_date = d.full_date
    left join {{ ref('dim_team') }} th on b.home_team = th.team_name
    left join {{ ref('dim_team') }} ta on b.away_team = ta.team_name
    left join {{ ref('dim_tournament') }} tn on b.tournament = tn.tournament
    left join {{ ref('dim_venue') }} v on b.country = v.country and b.city = v.city
),
goals_agg as (
    select match_key, sum(case when is_penalty then 1 else 0 end) as nb_penalty_goals,
           sum(case when is_own_goal then 1 else 0 end) as nb_own_goals, 1 as has_goal_detail
    from {{ ref('int_goals') }} group by match_key
),
shootouts_agg as (
    select s.match_key, dt.team_key as shootout_winner_key, 1 as has_shootout
    from {{ ref('int_shootouts') }} s left join {{ ref('dim_team') }} dt on s.winner = dt.team_name
)
select k.*, coalesce(sh.has_shootout, 0) as has_shootout, sh.shootout_winner_key,
       g.nb_penalty_goals, g.nb_own_goals, coalesce(g.has_goal_detail, 0) as has_goal_detail
from keys k
left join goals_agg g using (match_key)
left join shootouts_agg sh using (match_key)