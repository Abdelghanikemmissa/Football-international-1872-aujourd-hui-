select
    cast(date as date)        as match_date,
    trim(home_team)           as home_team,
    trim(away_team)           as away_team,
    trim(team)                as team,
    trim(scorer)              as scorer,
    cast(minute as integer)   as minute,
    cast(own_goal as boolean) as is_own_goal,
    cast(penalty as boolean)  as is_penalty
from {{ source('raw', 'goalscorers') }}