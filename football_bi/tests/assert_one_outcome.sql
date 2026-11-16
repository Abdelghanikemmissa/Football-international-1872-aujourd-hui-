select * from {{ ref('fact_match') }} 
where is_home_win + is_draw + is_away_win <> 1