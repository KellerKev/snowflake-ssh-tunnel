import duckdb
from duckdb.typing import *

duckdb.sql("set http_proxy='localhost:8080';")
res = duckdb.sql("SELECT * FROM 'http://10.0.0.x:3000/industry.csv';").fetchall()
print(res)

