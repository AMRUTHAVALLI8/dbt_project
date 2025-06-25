{{ config(
    materialized='table',
    schema='TRANSFORMED_POS',
    database='SILVER'
) }}

WITH base AS (
  SELECT
    CHANNEL,
    TRY_TO_DATE(DATE, 'DD-MM-YYYY') AS DATE,
    DIVISION,

    -- Extract BRAND from SKU
    CASE
      WHEN LEFT(SKU, 3) IN ('ABC', 'DEF', 'GHI') THEN LEFT(SKU, 3)
      ELSE NULL
    END AS BRAND,

    -- Extract PRODUCT
    SUBSTRING(SKU, 4, POSITION(' ' IN SKU) - 4) AS PRODUCT,

    -- FIXED: Convert to integer safely
    CAST(POS_UNITS AS INTEGER) AS POS_UNITS,
    PARTNER,
    SALES_ORG,

    TRY_CAST(SALES_ AS FLOAT) AS SALES,
    TRY_CAST(UNITS_ON_HAND AS INTEGER) AS UNITS_ON_HAND,

    STORE
  FROM {{ source('bronze', 'customer_pos') }}
  WHERE SKU IS NOT NULL
)

SELECT * FROM base
