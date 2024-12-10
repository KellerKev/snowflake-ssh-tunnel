use role accountadmin;

CREATE OR REPLACE WAREHOUSE spcs_tunnel_wh WITH WAREHOUSE_SIZE='X-SMALL';

create role spcs_tunnel_role;

grant usage on WAREHOUSE spcs_tunnel_wh  to role spcs_tunnel_role;
grant operate on  WAREHOUSE spcs_tunnel_wh to role spcs_tunnel_role;

grant create database on account to role spcs_tunnel_role;


grant role spcs_tunnel_role to user xxxxx;

use role spcs_tunnel_role;




create database spcs_tunnel_db;
create schema spcs_tunnel_schema;

--temporarily 
grant all privileges on database spcs_tunnel_db to role accountadmin;
grant all privileges on schema spcs_tunnel_schema to role accountadmin;

CREATE IMAGE REPOSITORY IF NOT EXISTS spcs_tunnel_images;

USE ROLE ACCOUNTADMIN;
alter user xxxxx set mins_to_bypass_mfa=180;

SHOW IMAGE REPOSITORIES IN SCHEMA;

--UPLOAD IMAGE NOW FIRST

USE ROLE ACCOUNTADMIN;
CREATE  COMPUTE POOL IF NOT EXISTS SPCS_TUNNEL_COMPUTE_POOL
  MIN_NODES = 1
  MAX_NODES = 1
  INSTANCE_FAMILY = CPU_X64_S
  AUTO_RESUME = true;

  DESCRIBE COMPUTE POOL SPCS_TUNNEL_COMPUTE_POOL;
  drop compute pool SPCS_TUNNEL_COMPUTE_POOL;
  
grant usage on compute pool SPCS_TUNNEL_COMPUTE_POOL to role spcs_tunnel_role;
grant operate on compute pool SPCS_TUNNEL_COMPUTE_POOL to role spcs_tunnel_role;
grant monitor on compute pool SPCS_TUNNEL_COMPUTE_POOL to role spcs_tunnel_role;
grant modify on compute pool SPCS_TUNNEL_COMPUTE_POOL to role spcs_tunnel_role;


GRANT BIND SERVICE ENDPOINT ON ACCOUNT TO ROLE spcs_tunnel_role;


use database spcs_tunnel_db;
use schema spcs_tunnel_schema;
CREATE NETWORK RULE allow_tunnel_rule
  TYPE = 'HOST_PORT'
  MODE= 'EGRESS'
  VALUE_LIST = ('x.x.x.x:22','0.0.0.0:443');

use database spcs_tunnel_db;
use schema spcs_tunnel_schema;


CREATE EXTERNAL ACCESS INTEGRATION allow_tunnel_eai
  ALLOWED_NETWORK_RULES=(allow_tunnel_rule)
  ENABLED=TRUE;

GRANT USAGE ON INTEGRATION allow_tunnel_eai TO ROLE spcs_tunnel_role;

use role spcs_tunnel_role;

revoke all privileges on database spcs_tunnel_db from role accountadmin;
revoke all privileges on schema spcs_tunnel_schema from role accountadmin;

  DESCRIBE COMPUTE POOL SPCS_TUNNEL_COMPUTE_POOL;

   drop  COMPUTE POOL SPCS_TUNNEL_COMPUTE_POOL;
  
CREATE or replace SECRET encodedstring
  TYPE=generic_string
  SECRET_STRING='IyEvYmluL2Jhc2ggCi9ob21lL3NwY3N0dW5uZWwvbWFtYmEvYmluL3B5dGhvbiAtbSB2ZW52IGRlZmF1bHRfcHlfZW52Ci4gL2hvbWUvc3Bjc3R1bm5lbC9kZWZhdWx0X3B5X2Vudi9iaW4vYWN0aXZhdGUgJiYgcGlwIGluc3RhbGwgdXYKY2QgL2hvbWUvc3Bjc3R1bm5lbCAmJiBnaXQgY2xvbmUgaHR0cHM6Ly9naXRodWIuY29tL0tlbGxlcktldi9kdWNrYmVyZwpjZCAvaG9tZS9zcGNzdHVubmVsL2R1Y2tiZXJnICYmIC4gL2hvbWUvc3Bjc3R1bm5lbC9kZWZhdWx0X3B5X2Vudi9iaW4vYWN0aXZhdGUgJiYgdXYgcGlwIGluc3RhbGwgLWUgLgoKbWtkaXIgL2hvbWUvc3Bjc3R1bm5lbC9qdXB5dGVyX25vdGVib29rcwpjaG93biBzcGNzdHVubmVsIC9ob21lL3NwY3N0dW5uZWwvanVweXRlcl9ub3RlYm9va3MKY3AgL2hvbWUvc3Bjc3R1bm5lbC9zYW1wbGVzL2ljZWJlcmdfbWluaW8uaXB5bmIgL2hvbWUvc3Bjc3R1bm5lbC9qdXB5dGVyX25vdGVib29rcwoKLiAvaG9tZS9zcGNzdHVubmVsL2RlZmF1bHRfcHlfZW52L2Jpbi9hY3RpdmF0ZSAmJiAgdXYgcGlwIGluc3RhbGwganVweXRlcmxhYgouIC9ob21lL3NwY3N0dW5uZWwvZGVmYXVsdF9weV9lbnYvYmluL2FjdGl2YXRlICYmIHV2IHBpcCBpbnN0YWxsIGh0dHB4PT0wLjI3LjIKLiAvaG9tZS9zcGNzdHVubmVsL2RlZmF1bHRfcHlfZW52L2Jpbi9hY3RpdmF0ZSAmJiB1diBwaXAgaW5zdGFsbCBmYXN0YXBpIHV2aWNvcm4KCiNjZCAvaG9tZS9zcGNzdHVubmVsICYmIGdpdCBjbG9uZSBodHRwczovL2dpdGh1Yi5jb20vanVweXRlcmxhYi9qdXB5dGVybGFiLmdpdAojY2QgL2hvbWUvc3Bjc3R1bm5lbC9qdXB5dGVybGFiICYmIC4gL2hvbWUvc3Bjc3R1bm5lbC9kZWZhdWx0X3B5X2Vudi9iaW4vYWN0aXZhdGUgJiYgdXYgcGlwIGluc3RhbGwgLWUgLiAmCiNjZCAvaG9tZS9zcGNzdHVubmVsL2p1cHl0ZXJsYWIgJiYgL2hvbWUvc3Bjc3R1bm5lbC9kZWZhdWx0X3B5X2Vudi9iaW4vamxwbSBydW4gYnVpbGQ6Y29yZQojY2QgL2hvbWUvc3Bjc3R1bm5lbC9qdXB5dGVybGFiICYmIC9ob21lL3NwY3N0dW5uZWwvZGVmYXVsdF9weV9lbnYvYmluL2p1cHl0ZXIgbGFiIGJ1aWxkCgouIC9ob21lL3NwY3N0dW5uZWwvZGVmYXVsdF9weV9lbnYvYmluL2FjdGl2YXRlICYmIHV2IHBpcCBpbnN0YWxsIGlweWtlcm5lbAoKLiAvaG9tZS9zcGNzdHVubmVsL2RlZmF1bHRfcHlfZW52L2Jpbi9hY3RpdmF0ZSAmJiBqdXB5dGVyIGxhYiAtLWlwICcqJyAtLXBvcnQgMzAwMCAtLW5vdGVib29rLWRpcj0vaG9tZS9zcGNzdHVubmVsL2p1cHl0ZXJfbm90ZWJvb2tzIC0tbm8tYnJvd3NlciAtLUlkZW50aXR5UHJvdmlkZXIudG9rZW49IiIgJgoKCgoKCmVjaG8gJ3NvdXJjZSAvaG9tZS9zcGNzdHVubmVsL2VudgpQT1JUMT0kKHNodWYgLWkgMjAwMC02NTAwMCAtbiAxKQpQT1JUMj0kKHNodWYgLWkgMjAwMC02NTAwMCAtbiAxKQpQT1JUMz0kKHNodWYgLWkgMjAwMC02NTAwMCAtbiAxKQpQT1JUND0kKHNodWYgLWkgMjAwMC02NTAwMCAtbiAxKQpQT1JUNT0kKHNodWYgLWkgMjAwMC02NTAwMCAtbiAxKQplY2hvICRQT1JUMyA+IC9ob21lL3NwY3N0dW5uZWwvcG9ydC50eHQKZWNobyAkUE9SVDMKZWNobyAkUE9SVDUgPiAvaG9tZS9zcGNzdHVubmVsL291dHNpZGVwb3J0LnR4dAplY2hvICRQT1JUNQpERUNPREVES0VZPSIkKHNvdXJjZSAvaG9tZS9zcGNzdHVubmVsL2VudiAmJiBlY2hvICRrZXkxIHwgYmFzZTY0IC0tZGVjb2RlKSIKZWNobyAkREVDT0RFREtFWQplY2hvICRTU0hfVVNFUgojRFlOQU1JQyBQT1JUIEZPUldBUkQgRlJPTSBDT05UQUlORVIgVE8gRE1aCgpzc2gtYWdlbnQgYmFzaCAtYyAic3NoLWFkZCA8KGVjaG8gIFwiJERFQ09ERURLRVlcIikgJiYgYXV0b3NzaCAgIC1NICRQT1JUMSAtbyBTdHJpY3RIb3N0S2V5Q2hlY2tpbmc9bm8gLW8gU2VydmVyQWxpdmVJbnRlcnZhbD02MCAtbyBFeGl0T25Gb3J3YXJkRmFpbHVyZT15ZXMgLWduTlQgIC1EIDEwODAgLUMgLU4gJFNTSF9VU0VSQCRETVpfSVAiICYKCiNPUFRJT05BTExZICBQT1JUIEZPUldBUkQgMzAwMSAoU3RyZWFtbGl0KSB0byBETVoKI3NzaC1hZ2VudCBiYXNoIC1jICJzc2gtYWRkIDwoZWNobyAgXCIkREVDT0RFREtFWVwiKSAmJiAgYXV0b3NzaCAgIC1NICRQT1JUNCAtbyBTdHJpY3RIb3N0S2V5Q2hlY2tpbmc9bm8gLW8gU2VydmVyQWxpdmVJbnRlcnZhbD02MCAtbyBFeGl0T25Gb3J3YXJkRmFpbHVyZT15ZXMgLWduTlQgLUMgLU4gIC1SIGxvY2FsaG9zdDokUE9SVDU6bG9jYWxob3N0OjMwMDIgICAkU1NIX1VTRVJAJERNWl9JUCIgJgoKI09QVElPTkFMTFkgIFBPUlQgRk9SV0FSRCAyMiAoU1NIKSB0byBETVoKI3NzaC1hZ2VudCBiYXNoIC1jICJzc2gtYWRkIDwoZWNobyAgXCIkREVDT0RFREtFWVwiKSAmJiAgYXV0b3NzaCAgIC1NICRQT1JUMiAtbyBTdHJpY3RIb3N0S2V5Q2hlY2tpbmc9bm8gLW8gU2VydmVyQWxpdmVJbnRlcnZhbD02MCAtbyBFeGl0T25Gb3J3YXJkRmFpbHVyZT15ZXMgLWduTlQgLUMgLU4gIC1SIGxvY2FsaG9zdDokUE9SVDM6bG9jYWxob3N0OjIyICAgJFNTSF9VU0VSQCRETVpfSVAiICYnID4gL2hvbWUvc3Bjc3R1bm5lbC90dW5uZWwuc2gKY2htb2QgK3ggL2hvbWUvc3Bjc3R1bm5lbC90dW5uZWwuc2gKL2hvbWUvc3Bjc3R1bm5lbC90dW5uZWwuc2ggJgpzbGVlcCA1Ci4gL2hvbWUvc3Bjc3R1bm5lbC9kZWZhdWx0X3B5X2Vudi9iaW4vYWN0aXZhdGUgJiYgY2QgL2hvbWUvc3Bjc3R1bm5lbC8gJiYgdXZpY29ybiByZXN0YXBpX2ljZWJlcmc6YXBwIC0taG9zdCAwLjAuMC4wIC0tcG9ydCAzMDAzIC0tcmVsb2FkICYKCmNkIC9ob21lL3NwY3N0dW5uZWwgJiYgbWtkaXIgc3RyZWFtbGl0X2FwcHMKY3AgL2hvbWUvc3Bjc3R1bm5lbC9zYW1wbGVzL3N0cmVhbWxpdC9tYWluLnB5IC9ob21lL3NwY3N0dW5uZWwvc3RyZWFtbGl0X2FwcHMKY2QgL2hvbWUvc3Bjc3R1bm5lbC8gJiYgLiAvaG9tZS9zcGNzdHVubmVsL2RlZmF1bHRfcHlfZW52L2Jpbi9hY3RpdmF0ZSAmJiB1diBwaXAgaW5zdGFsbCBzdHJlYW1saXQgbWl0b3NoZWV0IG51bXB5CiNjZCAvaG9tZS9zcGNzdHVubmVsL3N0cmVhbWxpdF9hcHBzICYmIC4gL2hvbWUvc3Bjc3R1bm5lbC9kZWZhdWx0X3B5X2Vudi9iaW4vYWN0aXZhdGUgJiYgc3RyZWFtbGl0IHJ1biBtYWluLnB5IC0tc2VydmVyLnBvcnQgMzAwMiAtLXNlcnZlci5hZGRyZXNzIDAuMC4wLjAgLS1zZXJ2ZXIucnVuT25TYXZlIHRydWUgICBlbmFibGVYc3JmUHJvdGVjdGlvbj1mYWxzZSBlbmFibGVDT1JTPWZhbHNlICYKY2QgL2hvbWUvc3Bjc3R1bm5lbC9zdHJlYW1saXRfYXBwcyAmJiAuIC9ob21lL3NwY3N0dW5uZWwvZGVmYXVsdF9weV9lbnYvYmluL2FjdGl2YXRlICYmIHN0cmVhbWxpdCBydW4gbWFpbi5weSAtLXNlcnZlci5wb3J0IDMwMDIgLS1zZXJ2ZXIuYWRkcmVzcyAwLjAuMC4wIC0tc2VydmVyLnJ1bk9uU2F2ZSB0cnVlIGVuYWJsZUNPUlM9ZmFsc2UgJgouIC9ob21lL3NwY3N0dW5uZWwvZGVmYXVsdF9weV9lbnYvYmluL2FjdGl2YXRlICYmIHV2IHBpcCBpbnN0YWxsIC1lIC9ob21lL3NwY3N0dW5uZWwvc3RyZWFtbGl0X2FwcHMvc3BhcmstMy41LjMtYmluLWhhZG9vcDMvcHl0aG9u';

  
CREATE SECRET servicesecrets
  TYPE=generic_string
SECRET_STRING='{
    "SSH_USER": "xxxxx",
    "DMZ_IP": "x.x.x.x",
    "SSHKEYS": [
        {
            "key1": ""
        }
    ]
}';


  CREATE SERVICE
  spcs_tunnel_service
  IN COMPUTE POOL SPCS_TUNNEL_COMPUTE_POOL
  EXTERNAL_ACCESS_INTEGRATIONS = (allow_tunnel_eai)
  MIN_INSTANCES=1
  MAX_INSTANCES=1
  FROM SPECIFICATION
  $$
    spec:
        containers:
         - name: "spcstunnelservice"
           image: "xxxx.xxxx.registry.snowflakecomputing.com/spcs_tunnel_db/spcs_tunnel_schema/spcs_tunnel_images/spcs_tunnel-image:latest"
           secrets:
            - snowflakeSecret: encodedstring
              envVarName: ENCODEDRUNSCRIPT
            - snowflakeSecret: servicesecrets
              envVarName: SERVICESECRETS
           env:
               SSHKEY: "True"
               ENVNAME: "snowtunnel" 
               VSVERSION: "1.95.2"
                   
        endpoints:
        - name: jupyter
          port: 3000
          public: true
        - name: vscode
          port: 3001
          public: true
        - name: streamlit
          port: 3002
          public: true
        - name: restapi
          port: 3003
  $$;


    

  
describe service spcs_tunnel_service;


alter service spcs_tunnel_service suspend;
alter service spcs_tunnel_service resume;

drop service spcs_tunnel_service;

SHOW SERVICE CONTAINERS IN SERVICE spcs_tunnel_service;



CALL SYSTEM$GET_SERVICE_LOGS('spcs_tunnel_service', '0', 'spcstunnelservice', 1000);
SHOW ENDPOINTS IN SERVICE spcs_tunnel_service;



CREATE OR REPLACE FUNCTION query_taxis_udf(sql_query STRING)
returns variant
SERVICE=spcs_tunnel_service
ENDPOINT=restapi
AS '/snowflake_function';



SELECT query_taxis_udf('SELECT * FROM "nyc.taxis" LIMIT 10');




WITH udf_output AS (
    SELECT
        query_taxis_udf('SELECT * FROM "nyc.taxis" LIMIT 100') AS json_result
),
flattened AS (
    SELECT
        VALUE:DOLocationID::INTEGER AS DOLocationID,
        VALUE:PULocationID::INTEGER AS PULocationID,
        VALUE:RatecodeID::FLOAT AS RatecodeID,
        VALUE:VendorID::INTEGER AS VendorID,
        VALUE:airport_fee::FLOAT AS airport_fee,
        VALUE:congestion_surcharge::FLOAT AS congestion_surcharge,
        VALUE:extra::FLOAT AS extra,
        VALUE:fare_amount::FLOAT AS fare_amount,
        VALUE:improvement_surcharge::FLOAT AS improvement_surcharge,
        VALUE:mta_tax::FLOAT AS mta_tax,
        VALUE:passenger_count::FLOAT AS passenger_count,
        VALUE:payment_type::INTEGER AS payment_type,
        VALUE:store_and_fwd_flag::STRING AS store_and_fwd_flag,
        VALUE:tip_amount::FLOAT AS tip_amount,
        VALUE:tolls_amount::FLOAT AS tolls_amount,
        VALUE:total_amount::FLOAT AS total_amount,
        VALUE:tpep_dropoff_datetime::TIMESTAMP AS tpep_dropoff_datetime,
        VALUE:tpep_pickup_datetime::TIMESTAMP AS tpep_pickup_datetime,
        VALUE:trip_distance::FLOAT AS trip_distance
    FROM udf_output, LATERAL FLATTEN(INPUT => json_result)
)
SELECT * FROM flattened;



CREATE OR REPLACE PROCEDURE flatten_query_taxis_sp(
    p_col_list VARCHAR,
    p_table_name VARCHAR,
    p_row_limit NUMBER
)
RETURNS TABLE (
    DOLocationID NUMBER,
    PULocationID NUMBER,
    RatecodeID NUMBER,
    VendorID NUMBER,
    airport_fee NUMBER,
    congestion_surcharge NUMBER,
    extra NUMBER,
    fare_amount NUMBER,
    improvement_surcharge NUMBER,
    mta_tax NUMBER,
    passenger_count NUMBER,
    payment_type NUMBER,
    store_and_fwd_flag VARCHAR,
    tip_amount NUMBER,
    tolls_amount NUMBER,
    total_amount NUMBER,
    tpep_dropoff_datetime TIMESTAMP_NTZ,
    tpep_pickup_datetime TIMESTAMP_NTZ,
    trip_distance NUMBER
)
LANGUAGE SQL
AS
$$
DECLARE
    result_sql STRING;
    result_set RESULTSET;
BEGIN
    -- Construct the SQL query
    result_sql :=
        'WITH udf_output AS (
            SELECT query_taxis_udf(''SELECT ' || p_col_list || ' FROM "' || p_table_name || '" LIMIT ' || p_row_limit || ''') AS json_result
        ),
        flattened AS (
            SELECT
                VALUE:DOLocationID::NUMBER,
                VALUE:PULocationID::NUMBER,
                VALUE:RatecodeID::NUMBER,
                VALUE:VendorID::NUMBER,
                VALUE:airport_fee::NUMBER,
                VALUE:congestion_surcharge::NUMBER,
                VALUE:extra::NUMBER,
                VALUE:fare_amount::NUMBER,
                VALUE:improvement_surcharge::NUMBER,
                VALUE:mta_tax::NUMBER,
                VALUE:passenger_count::NUMBER,
                VALUE:payment_type::NUMBER,
                VALUE:store_and_fwd_flag::VARCHAR,
                VALUE:tip_amount::NUMBER,
                VALUE:tolls_amount::NUMBER,
                VALUE:total_amount::NUMBER,
                VALUE:tpep_dropoff_datetime::TIMESTAMP_NTZ,
                VALUE:tpep_pickup_datetime::TIMESTAMP_NTZ,
                VALUE:trip_distance::NUMBER
            FROM udf_output, LATERAL FLATTEN(INPUT => json_result)
        )
        SELECT * FROM flattened';

    -- Execute the dynamic SQL query and store the result in a RESULTSET variable
    result_set := (EXECUTE IMMEDIATE :result_sql);

    -- Return the RESULTSET
    RETURN TABLE(result_set);
END;
$$;



SELECT *
FROM TABLE(
    flatten_query_taxis_sp(
        'DOLocationID, PULocationID, fare_amount, trip_distance',
        'nyc.taxis',
        10
    )
);
