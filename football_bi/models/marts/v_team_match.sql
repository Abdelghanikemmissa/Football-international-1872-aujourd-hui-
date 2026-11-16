select match_key, date_key, tournament_key, home_team_key as team_key, away_team_key as opponent_key,
       home_score as goals_for, away_score as goals_against,
       case when home_score > away_score then 3 when home_score = away_score then 1 else 0 end as points,
       has_shootout as shootout_played, case when shootout_winner_key = home_team_key then 1 else 0 end as shootout_won
from {{ ref('fact_match') }}
union all
select match_key, date_key, tournament_key, away_team_key, home_team_key, away_score, home_score,
       case when away_score > home_score then 3 when away_score = home_score then 1 else 0 end,
       has_shootout, case when shootout_winner_key = away_team_key then 1 else 0 end
from {{ ref('fact_match') }}