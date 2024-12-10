from duckberg import DuckBerg


MINIO_URI = "http://10.0.0.11:9000";
MINIO_USER = "admin"
MINIO_PASSWORD = "password"

import os


os.environ['HTTP_PROXY'] = os.environ['http_proxy'] = 'http://localhost:8080/'


catalog_config: dict[str, str] = {
  "type": "rest",
  "uri": "http://10.0.0.11:8181/",
  "credentials": "admin:password",
  "s3.proxy-uri":"http://localhost:8080",
  "s3.region": "us-east-1",
  "s3.use.ssl": "false",
  "s3.url.style": "path",
  "s3.endpoint": MINIO_URI,
  "s3.access-key-id": MINIO_USER,
  "s3.secret-access-key": MINIO_PASSWORD
}



db = DuckBerg(
        catalog_name="warehouse",
        catalog_config=catalog_config)


tables = db.list_tables()
print (tables)

partitions = db.list_partitions(table="nyc.taxis")
print(partitions)

query = "SELECT * FROM 'nyc.taxis' WHERE payment_type = 1 AND trip_distance > 40 ORDER BY tolls_amount DESC"
df = db.select(sql=query).read_pandas()
print(df.head(10))
