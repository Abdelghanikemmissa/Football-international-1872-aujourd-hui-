select
    cast(date as date)                 as match_date,
    trim(home_team)                    as home_team,
    trim(away_team)                    as away_team,
    cast(home_score as integer)        as home_score,
    cast(away_score as integer)        as away_score,
    trim(tournament)                   as tournament,
    trim(city)                         as city,
    trim(country)                      as country,
    cast(neutral as boolean)           as is_neutral
from {{ source('raw', 'results') }}