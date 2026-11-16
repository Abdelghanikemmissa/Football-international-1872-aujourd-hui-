import duckdb
con = duckdb.connect("dev.duckdb") 
con.sql("create schema if not exists raw")
for t in ["results", "shootouts", "goalscorers", "former_names"]:
    con.sql(f"create or replace table raw.{t} as "
            f"select * from read_csv_auto('data/raw/{t}.csv')")
print("Chargement terminé !")