# **Snowflake Environment**

---

### Step 1: Create the Database and Schema
In Snowflake, the Database is the top-level container, and the Schema is a logical grouping within it. We will create a dedicated database for this project to keep it isolated from other work.

```sql
-- 1. Create a dedicated Database for the project
CREATE OR REPLACE DATABASE SNOW_LOADING_PROJ_DB;

-- 2. Create a Schema for your raw data (Landing Zone)
CREATE OR REPLACE SCHEMA SNOW_LOADING_PROJ_DB.RAW_DATA_SCHEMA;

-- 3. Set the context to use this database and schema automatically
USE DATABASE SNOW_LOADING_PROJ_DB;
USE SCHEMA RAW_DATA_SCHEMA;
```

### Step 2: Create a Virtual Warehouse (Compute Engine)
The Warehouse is the engine that provides the RAM and CPU to run your queries[cite: 1]. We will set it to `XSMALL` to save credits and enable `AUTO_SUSPEND` so it shuts down when not in use.

```sql
-- Create a Warehouse optimized for development
CREATE OR REPLACE WAREHOUSE SNOW_LOADING_WH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 300      -- Automatically shuts down after 5 minutes of idle time
    AUTO_RESUME = TRUE      -- Automatically restarts when you run a query
    INITIALLY_SUSPENDED = TRUE 
    COMMENT = 'Compute engine for Snowflake Data Loading Project';

-- Set the context to use this warehouse
USE WAREHOUSE SNOW_LOADING_WH;
```

### Step 3: Configure Security (Roles and Users)
Following security best practices, we should not use the `ACCOUNTADMIN` role for day-to-day tasks. We will create a custom role, grant it specific permissions, and assign it to your user.

```sql
-- 1. Create a custom Role for this project
CREATE OR REPLACE ROLE SNOW_PROJ_ADMIN_ROLE;

-- 2. Grant usage permissions on the Database, Schema, and Warehouse
GRANT USAGE ON DATABASE SNOW_LOADING_PROJ_DB TO ROLE SNOW_PROJ_ADMIN_ROLE;
GRANT ALL PRIVILEGES ON SCHEMA SNOW_LOADING_PROJ_DB.RAW_DATA_SCHEMA TO ROLE SNOW_PROJ_ADMIN_ROLE;
GRANT USAGE ON WAREHOUSE SNOW_LOADING_WH TO ROLE SNOW_PROJ_ADMIN_ROLE;

-- 3. Assign this Role to your current User
-- (First, we find your username dynamically)
SET MY_USER_VAR = CURRENT_USER();
GRANT ROLE SNOW_PROJ_ADMIN_ROLE TO USER IDENTIFIER($MY_USER_VAR);

-- 4. Switch to the new role to start working
USE ROLE SNOW_PROJ_ADMIN_ROLE;
```

---

### Verification: Checklist
Run this command to verify that your environment is correctly set up:

```sql
SELECT CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();
```

**What you have achieved:**
*   **Logical Isolation:** You have a specific database (`SNOW_LOADING_PROJ_DB`) and schema.
*   **Cost Control:** Your warehouse (`SNOW_LOADING_WH`) will only run when needed and won't waste money.
*   **Access Control:** You are now operating under a secure, dedicated role (`SNOW_PROJ_ADMIN_ROLE`).

---