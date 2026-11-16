select * from {{ ref('fact_match') }} 
where has_shootout = 1 and shootout_winner_key not in (home_team_key, away_team_key)