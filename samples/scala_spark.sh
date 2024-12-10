#!/bin/bash

# Set Java Home
export JAVA_HOME="/home/spcstunnel/.sdkman/candidates/java/current"
export PATH="$JAVA_HOME/bin:$PATH"

# AWS Credentials
export AWS_REGION="us-east-1"
export AWS_ACCESS_KEY_ID="admin"
export AWS_SECRET_ACCESS_KEY="password"

# Run Spark Shell with Iceberg Configuration
spark-shell \
  --master local[*] \
  --conf "spark.sql.catalog.my_catalog=org.apache.iceberg.spark.SparkCatalog" \
  --conf "spark.jars.packages=org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.5.2,org.apache.hadoop:hadoop-aws:3.4.1" \
  --conf "spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions" \
  --conf "spark.driver.extraJavaOptions=-DsocksProxyHost=localhost" \
  --conf "spark.executor.extraJavaOptions=-DsocksProxyHost=localhost" \
  --conf "spark.sql.catalog.my_catalog.type=rest" \
  --conf "spark.sql.catalog.my_catalog.use.ssl=false" \
  --conf "spark.hadoop.fs.s3a.aws.credentials.provider=org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider" \
  --conf "spark.sql.catalog.my_catalog.client.auth.type=basic" \
  --conf "spark.sql.catalog.my_catalog.client.auth.user=admin" \
  --conf "spark.sql.catalog.my_catalog.client.auth.password=password" \
  --conf "spark.sql.catalog.my_catalog.s3.path-style-access=true" \
  --conf "spark.sql.catalog.my_catalog.client.http.proxy.host=localhost" \
  --conf "spark.sql.catalog.my_catalog.client.http.proxy.port=8080" \
  --conf "spark.sql.catalog.my_catalog.http.proxy.host=localhost" \
  --conf "spark.sql.catalog.my_catalog.http.proxy.port=8080" \
  --conf "spark.sql.catalog.my_catalog.http-client.proxy.host=localhost" \
  --conf "spark.sql.catalog.my_catalog.http-client.proxy.port=8080" \
  --conf "spark.sql.catalog.my_catalog.http-client.http.proxy.host=localhost" \
  --conf "spark.sql.catalog.my_catalog.http-client.http.proxy.port=8080" \
  --conf "spark.sql.catalog.my_catalog.http-client.proxy-endpoint=http://localhost:8080" \
  --conf "spark.sql.catalog.my_catalog.http-client.type=apache" \
  --conf "spark.sql.catalog.my_catalog.s3.endpoint = http://10.0.0.11:9000" \
  --conf "spark.hadoop.fs.s3a.endpoint=http://10.0.0.11:9000" \
  --conf "spark.sql.catalog.my_catalog.uri=http://10.0.0.11:8181" \
  --conf "spark.sql.defaultCatalog=my_catalog" << 'EOF'

// Scala commands to execute in Spark Shell
import org.apache.spark.sql.SparkSession

try {
  spark.sql("SHOW CATALOGS").show()
  spark.sql("SHOW DATABASES").show()
  spark.sql("SELECT * FROM nyc.taxis WHERE payment_type = 1 AND trip_distance > 40 ORDER BY tolls_amount DESC").show()
} catch {
  case e: Exception => println(s"Error: ${e.getMessage}")
}


EOF