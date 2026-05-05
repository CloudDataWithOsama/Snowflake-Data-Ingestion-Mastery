-- 1. Create the Pipe
CREATE OR REPLACE PIPE MY_SNOWPIPE
  AUTO_INGEST = TRUE
  AS
  COPY INTO TSLA_STOCK_DATA
  FROM @MY_S3_STAGE
  FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);

-- 2. Get the ARN for S3 Event Notification
SHOW PIPES;
-- Copy 'notification_channel' value for AWS S3 setup.