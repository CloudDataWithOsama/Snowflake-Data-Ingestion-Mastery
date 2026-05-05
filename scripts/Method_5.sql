-- 1. Create Storage Integration (Admin Task)
CREATE OR REPLACE STORAGE INTEGRATION S3_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('s3://your-bucket-name/')
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::1234567890:role/SnowflakeRole';

-- 2. Get Integration details for AWS Trust Relationship
DESC INTEGRATION S3_INT;

-- 3. Create Stage using the Integration
CREATE OR REPLACE STAGE MY_SECURE_S3_STAGE
  STORAGE_INTEGRATION = S3_INT
  URL = 's3://your-bucket-name/'
  FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);

-- 4. Secure Loading
COPY INTO TSLA_STOCK_DATA
FROM @MY_SECURE_S3_STAGE/TSLA.csv
ON_ERROR = 'CONTINUE';