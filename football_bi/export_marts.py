import duckdb, os
con = duckdb.connect("dev.duckdb")
os.makedirs("exports", exist_ok=True)

tables = ["dim_date", "dim_team", "dim_tournament", "dim_venue", "fact_match", "v_team_match"]
for t in tables:
    con.sql(f"copy main.{t} to 'exports/{t}.csv' (header, delimiter ',')")
    print(f"Exporté : exports/{t}.csv")