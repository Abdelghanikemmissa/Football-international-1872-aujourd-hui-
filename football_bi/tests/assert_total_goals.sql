select * from {{ ref('fact_match') }} 
where total_goals <> home_score + away_score