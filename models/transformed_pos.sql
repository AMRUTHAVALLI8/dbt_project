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

    CASE
      WHEN LEFT(SKU, 3) IN ('ABC', 'DEF', 'GHI') THEN LEFT(SKU, 3)
      ELSE NULL
    END AS BRAND,

    SUBSTRING(SKU, 4, POSITION(' ' IN SKU) - 4) AS PRODUCT,

    TRY_CAST(POS_UNITS AS INTEGER) AS POS_UNITS,
    PARTNER,
    SALES_ORG,

    TRY_CAST(SPLIT(SALES_UNITS_OI, ' ')[0] AS FLOAT) AS SALES,
    TRY_CAST(SPLIT(SALES_UNITS_OI, ' ')[1] AS INTEGER) AS UNITS_ON_HAND,

    TRY_CAST(STORE AS INTEGER) AS STORE

  FROM {{ source('bronze', 'customer_pos') }}
  WHERE SKU IS NOT NULL
)

SELECT * FROM base
