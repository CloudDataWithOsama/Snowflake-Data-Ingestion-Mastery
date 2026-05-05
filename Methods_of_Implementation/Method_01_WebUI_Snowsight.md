## 🌐 Method 1: Data Ingestion via Snowflake Web Interface (Snowsight)

The Snowflake Web Interface provides a user-friendly, wizard-driven approach to quickly load local data files into tables. This method is ideal for small to medium-sized datasets and manual data entry tasks.

### **Step 1: Environment and Table Preparation**
First, ensure the target table is created and the session context is set correctly to your project's database and schema.

```sql
-- Set the session context
USE ROLE SNOW_PROJ_ADMIN_ROLE;
USE DATABASE SNOW_LOADING_PROJ_DB;
USE SCHEMA RAW_DATA_SCHEMA;
USE WAREHOUSE SNOW_LOADING_WH;

-- Create the target table structure
CREATE OR REPLACE TABLE CUSTOMER_DETAILS (
    FIRST_NAME STRING,
    LAST_NAME STRING,
    ADDRESS STRING,
    CITY STRING,
    STATE STRING
);

-- Verify the table is currently empty
SELECT * FROM CUSTOMER_DETAILS;
```

### **Step 2: Navigating the Load Wizard**
1.  Navigate to **Ingestion** > **Add Data** > **Load Data into Table** using the left-hand sidebar.
2.  **File Selection**: Browse and select the `customer_detail.csv` file from your local machine.
3.  **Target Selection**: Choose the `SNOW_LOADING_PROJ_DB` database, `RAW_DATA_SCHEMA` schema, and the `CUSTOMER_DETAILS` table. Click **Next**.

### **Step 3: Configuring File Format and Security**
To ensure the data is parsed correctly, the following settings were applied:
*   **File Format**: CSV.
*   **Field Delimiter**: Set to **Pipe (|)**, as the source file uses pipe separation.
*   **Header Selection**: Enabled "Skip first line" to avoid importing column headers as data.
*   **Warehouse**: Used the `SNOW_LOADING_WH` to provide the compute power for the ingestion.

### **Step 4: Final Ingestion and Verification**
Once the configuration was validated in the data preview, the **Load** button was clicked to execute the ingestion.

Finally, run the following query to verify the data was successfully committed to the table:
```sql
SELECT * FROM CUSTOMER_DETAILS;
```

---