# ☁️ Method 3: Data Ingestion via External Stage (AWS S3)

This method demonstrates how to load data from an **External Cloud Storage (AWS S3)** into Snowflake. This is the standard approach for production-grade ETL pipelines.

## 🛠️ Configuration
*   **Storage**: Data is hosted on AWS S3.
*   **Authentication**: Secure access is managed via AWS IAM Access Keys (Access Key ID & Secret Access Key).

### **Step 1: Prepare your AWS S3 Bucket**
Before writing any SQL, you need to have your file in the cloud:
1.  **Login** to your AWS Console.
2.  **Upload** the `TSLA.csv` file into an S3 bucket.
3.  **Note down** your:
    *   S3 Bucket Name (e.g., `s3://osama-data-bucket/`)
    *   AWS Access Key ID
    *   AWS Secret Access Key

### **Step 2: Set Your Environment**
Ensure you are in the right database and schema:
```sql
USE ROLE SNOW_PROJ_ADMIN_ROLE;
USE WAREHOUSE SNOW_LOADING_WH;
USE DATABASE SNOW_LOADING_PROJ_DB;
USE SCHEMA RAW_DATA_SCHEMA;
```

### **Step 3: Create the Target Table in Snowflake**
Run this in your **SnowSQL terminal** or Web UI to create a table specifically for the Tesla stock data:

```sql
CREATE OR REPLACE TABLE TSLA_STOCK_DATA (
    DATE DATE,
    OPEN FLOAT,
    HIGH FLOAT,
    LOW FLOAT,
    CLOSE FLOAT,
    ADJ_CLOSE FLOAT,
    VOLUME INT
);
```

### **Step 4: Create the External Stage**
This command creates a "bridge" between Snowflake and your AWS S3 bucket. Replace the placeholders with your actual AWS keys:

```sql
CREATE OR REPLACE STAGE MY_S3_STAGE
  URL = 's3://your-bucket-name/'
  CREDENTIALS = (
    AWS_KEY_ID = 'ENTER_YOUR_ACCESS_KEY_HERE' 
    AWS_SECRET_KEY = 'ENTER_YOUR_SECRET_KEY_HERE'
  )
  FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);
```

### **Step 5: Load the Data (The COPY Command)**
Since the file is already in the cloud, we don't need a `PUT` command. We can pull it directly into the table:

```sql
COPY INTO TSLA_STOCK_DATA
FROM @MY_S3_STAGE/TSLA.csv
ON_ERROR = 'CONTINUE';
```

### **Step 6: Verify the Results**
Confirm the stock data has been ingested:

```sql
SELECT * FROM TSLA_STOCK_DATA LIMIT 10;
```

---

## 📊 Benefits
*   **Scalability**: Handles massive datasets stored in the cloud.
*   **Automation Ready**: This setup is a prerequisite for configuring **Snowpipe** for continuous data ingestion.

---

### **Quick Troubleshooting Tips for Method 3:**
*   **Access Denied:** Ensure your AWS IAM user has `s3:GetObject` and `s3:ListBucket` permissions for that specific bucket.
*   **Date Format:** If the `DATE` column in your CSV is in a non-standard format (like `MM/DD/YYYY`), you might need to adjust your `FILE_FORMAT` to include `DATE_FORMAT = 'MM/DD/YYYY'`.
*   **No PUT required:** Remember, `PUT` is only for moving files from your **local PC** to Snowflake. In Method 3, the data is already in the cloud, so we bypass that step entirely.