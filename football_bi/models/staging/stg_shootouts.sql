select
    cast(date as date)      as match_date,
    trim(home_team)         as home_team,
    trim(away_team)         as away_team,
    trim(winner)            as winner,
    trim(first_shooter)     as first_shooter
from {{ source('raw', 'shootouts') }}