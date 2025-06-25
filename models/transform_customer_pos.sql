WITH raw AS (
    SELECT
        CHANNEL,
        TRY_TO_DATE(DATE, 'YYYY-MM-DD') AS DATE,
        DIVISION,
        CASE 
            WHEN LEFT(SKU, 3) IN ('ABC', 'DEF', 'GHI') THEN LEFT(SKU, 3)
            ELSE NULL 
        END AS BRAND,
        REGEXP_SUBSTR(SKU, '(?<=^[A-Z]{3})\\d+') AS PRODUCT,
        TRY_CAST(POS_UNITS AS INTEGER) AS POS_UNITS,
        PARTNER,
        SALES_ORG,
        TRY_CAST(SALES_ AS FLOAT) AS SALES,
        TRY_CAST(UNITS_ON_HAND AS INTEGER) AS UNITS_ON_HAND,
        STORE,
        WH
    FROM {{ source('bronze', 'customer_pos') }}
)

SELECT * FROM raw;
