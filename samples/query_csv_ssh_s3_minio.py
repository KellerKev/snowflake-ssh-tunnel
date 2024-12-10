import duckdb
from duckdb.typing import *


duckdb.sql("set http_proxy='localhost:8080';")
duckdb.sql("SET s3_region='us-east-1';")
duckdb.sql("SET s3_url_style='path';")
duckdb.sql("SET s3_endpoint='10.0.0.11:9000';")
duckdb.sql("SET s3_access_key_id='ROOTUSER';")
duckdb.sql("SET s3_secret_access_key='CHANGEME123';")
duckdb.sql("SET s3_use_ssl='false';")

duckdb.sql("CREATE TABLE bookings AS SELECT * FROM read_csv_auto('s3://testdata/hotel_bookings.csv', all_varchar=1);")

#res=duckdb.sql("SELECT COUNT(*) AS TotalRows from bookings;").fetchall()
res=duckdb.sql("SELECT * from bookings limit 10;").fetchall()
print (res)
