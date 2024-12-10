from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Dict, Any
import pandas as pd
from duckberg import DuckBerg
import os
import logging


# Initialize logging
logging.basicConfig(level=logging.DEBUG)

# Define FastAPI app
app = FastAPI()

# DuckBerg configuration
MINIO_URI = "http://10.0.0.11:9000"
MINIO_USER = "admin"
MINIO_PASSWORD = "password"

os.environ['HTTP_PROXY'] = os.environ['http_proxy'] = 'http://localhost:8080/'

catalog_config = {
    "type": "rest",
    "uri": "http://10.0.0.11:8181/",
    "credentials": "admin:password",
    "s3.proxy-uri": "http://localhost:8080",
    "s3.region": "us-east-1",
    "s3.use.ssl": "false",
    "s3.url.style": "path",
    "s3.endpoint": MINIO_URI,
    "s3.access-key-id": MINIO_USER,
    "s3.secret-access-key": MINIO_PASSWORD,
}

# Initialize DuckBerg
try:
    db = DuckBerg(catalog_name="warehouse", catalog_config=catalog_config)
    logging.info("DuckBerg initialized successfully.")
except Exception as e:
    logging.error(f"Failed to initialize DuckBerg: {e}")
    raise

# Input model for Snowflake external function
class SnowflakeRequest(BaseModel):
    data: List[List[Any]]  # Input is a list of lists (Snowflake JSON format)

@app.post("/snowflake_function", response_model=Dict[str, Any])
async def snowflake_function(request: SnowflakeRequest):
    try:
        # Extract input data from Snowflake
        input_data = request.data
        
        if not input_data or len(input_data[0]) < 1:
            raise ValueError("Invalid input: query is required.")

        # The first item in the input array is the SQL query
        query = input_data[0]
        query=query[1]
        #print (query[1])
        logging.debug(f"Received query: {query}")

        # Execute the query using DuckBerg
        df = db.select(sql=query).read_pandas()

        # Log DataFrame information
        logging.debug(f"DataFrame shape: {df.shape}")
        if not df.empty:
            logging.debug(f"DataFrame preview: {df.head(5).to_dict(orient='records')}")

        # Convert DataFrame to a JSON-serializable dictionary
        df_json = df.to_dict(orient="records")
        
        # Wrap the output in the expected Snowflake format: [index, data]
        response = {"data": [[0, df_json]]}

        

        # Return the formatted response
        return response

    except Exception as e:
        # Log the exception for debugging
        logging.exception("An error occurred during query execution.")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

# Health check endpoint
@app.get("/health")
async def health():
    return {"status": "healthy"}
