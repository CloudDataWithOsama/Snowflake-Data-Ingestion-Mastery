# ⚡ Method 4: Automated Continuous Ingestion via Snowpipe

This method demonstrates the implementation of a **serverless, event-driven data pipeline**. By leveraging **Snowpipe**, we eliminate the need for manual `COPY INTO` commands, allowing Snowflake to automatically ingest data the moment a new file lands in the AWS S3 bucket.

## ⚙️ Automation Architecture
*   **Trigger**: AWS S3 Event Notifications (ObjectCreated).
*   **Messaging**: Snowflake-managed **SQS (Simple Queue Service)** notification channel.
*   **Ingestion Engine**: Snowpipe with `AUTO_INGEST` enabled.

---

## 🚀 Implementation Workflow

### 1. Define the Pipe Object
The Pipe object "wraps" the loading logic. It listens for notifications and executes the ingestion automatically.
```sql
CREATE OR REPLACE PIPE MY_SNOWPIPE
  AUTO_INGEST = TRUE
  AS
  COPY INTO TSLA_STOCK_DATA
  FROM @MY_S3_STAGE
  FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);
```
> **Note:** `AUTO_INGEST = TRUE` configures the pipe to ingest data as soon as it receives an S3 event notification.

### 2. Retrieve the SQS Queue ARN
Snowflake provides a unique SQS ARN for every pipe. This ARN acts as the "destination address" for AWS notifications.
```sql
SHOW PIPES;
```
*   Locate the `notification_channel` column in the results.
*   **Action**: Copy the ARN string (e.g., `arn:aws:sqs:us-east-1:1234567890:sf-snowpipe-...`).

### 3. Configure AWS S3 Event Notifications
To bridge the gap between S3 and Snowflake, the bucket must be configured to alert Snowpipe of new uploads.
1.  **Navigate** to the **Properties** tab of your S3 bucket in the AWS Console.
2.  **Create Event Notification**:
    *   **Event Name**: `SnowpipeIngestEvent`
    *   **Event Types**: Select `All object create events` (`s3:ObjectCreated:*`).
    *   **Destination**: Select `SQS Queue`.
    *   **Specify SQS Queue**: Select `Enter SQS Queue ARN` and paste the ARN copied from Step 2.

---

## 🧪 Testing the Pipeline (End-to-End)

To verify the automation, we perform a live data upload test:

1.  **Prepare File**: Rename a local data file (e.g., `TSLA.csv` to `TSLA_batch_02.csv`).
2.  **Upload**: Drop the file into the monitored S3 bucket.
3.  **Latency**: Wait approximately 60 seconds for the cloud-to-cloud notification to trigger.
4.  **Verification Query**:
    ```sql
    SELECT COUNT(*) FROM TSLA_STOCK_DATA;
    ```
    *If the row count has increased, the Snowpipe automation is confirmed functional.*

---

## 💎 Key Benefits
*   **Real-time Insights**: Data is available for analysis within seconds of being generated or received.
*   **Cost Efficiency**: Serverless compute costs are only incurred when data is actually being moved.
*   **Zero-Touch ETL**: Once configured, the pipeline requires no manual oversight or maintenance.

---