with teams as (
    select home_team as team_name from {{ ref('int_matches') }}
    union select away_team from {{ ref('int_matches') }}
),
confed as (
    select team, confederation, continent, cast(is_historical as integer) as is_historical from {{ ref('confederations') }}
)
select
    row_number() over (order by t.team_name) as team_key,
    t.team_name,
    coalesce(c.confederation, 'Inconnue') as confederation,
    coalesce(c.continent, 'Inconnu') as continent,
    coalesce(c.is_historical, 0) as is_historical
from teams t left join confed c on t.team_name = c.team