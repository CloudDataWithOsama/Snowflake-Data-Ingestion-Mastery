# 💻 Method 2: Data Ingestion via SnowSQL (CLI)

This method demonstrates the process of loading local data into Snowflake using the **SnowSQL Command Line Interface**. This approach is a standard practice for data engineers as it allows for scripting, automation, and handling larger datasets more efficiently than the web-based GUI.

---

## 🛠️ Prerequisites
*   **SnowSQL Installed**:
        url: https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.3/index.html
        Download Latest File: (e.g. snowsql-1.3.x-windows_x86_64.msi)
*   **Verification**: Verified via `snowsql -v` in the terminal.
*   **Local Data File**: A pipe-delimited CSV file located at a known directory path.

---

## 🚀 Implementation Steps

### 1. Establish Connection
Connect to the Snowflake instance using the Account Identifier and User credentials:
```bash
snowsql -a <your_account_identifier> -u <your_username>
```
*Note: The password is entered securely without visual feedback in the terminal.*

Now, All commands run in CMD (SnowSQL)

### 2. Set Session Context
Once logged in, the environment context is set to ensure commands are executed within the correct database and schema:
```sql
USE ROLE SNOW_PROJ_ADMIN_ROLE;
USE WAREHOUSE SNOW_LOADING_WH;
USE DATABASE SNOW_LOADING_PROJ_DB;
USE SCHEMA RAW_DATA_SCHEMA;
```

### 3. Create an Internal Stage
An **Internal Stage** is created as a secure, temporary storage area within Snowflake to hold files before they are loaded into tables:
```sql
CREATE OR REPLACE STAGE MY_INTERNAL_STAGE;
```

### 4. Stage the File (PUT Command)
The `PUT` command is used to upload the local file to the newly created Snowflake stage:
```sql
PUT file://<file path> @MY_INTERNAL_STAGE;
```
*   **Status**: Successfully verified as `UPLOADED` in the terminal.

### 5. Ingest Data (COPY INTO Command)
The final step is to move the data from the internal stage into the target table using the `COPY INTO` command. This command specifies the file format logic (Pipe delimiter and skipping the header):
```sql
COPY INTO CUSTOMER_DETAILS
FROM @MY_INTERNAL_STAGE
FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = '|' SKIP_HEADER = 1)
ON_ERROR = 'CONTINUE';
```

---

## 🔍 Verification
To ensure the data ingestion was successful, a simple selection query is executed:
```sql
SELECT * FROM CUSTOMER_DETAILS;
```
**Result**: The table is populated with the records from the `customer_detail.csv` file, confirming the CLI pipeline is functional.

---

## 💡 Key Takeaway
Using **SnowSQL** provides a foundation for building automated pipelines. Unlike Method 1 (Web UI), this method separates the **Staging** (uploading to cloud) and **Ingestion** (copying to table) phases, which is critical for handling large-scale data engineering tasks.

---