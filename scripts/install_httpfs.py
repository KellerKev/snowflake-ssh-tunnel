import duckdb
con = duckdb.connect(database=":memory:", read_only=False)
con.execute("INSTALL 'httpfs';")
