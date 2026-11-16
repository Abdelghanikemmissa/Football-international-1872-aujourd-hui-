select
    trim(current)              as current_name,
    trim(former)               as former_name,
    cast(start_date as date)   as start_date,
    cast(end_date as date)     as end_date
from {{ source('raw', 'former_names') }}