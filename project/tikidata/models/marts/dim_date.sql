WITH DateRange AS (
  -- 1. Generate the sequence of numbers
  SELECT 
    ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS Offset
  FROM TABLE(GENERATOR(ROWCOUNT => 50000)) 
),
Dates AS (
  -- 2. Convert offsets into actual date objects
  SELECT 
    DATEADD(DAY, Offset, '2015-01-01'::DATE) AS Date_Val
  FROM DateRange
)
-- 3. Extract dimensions
SELECT
    TO_CHAR(Date_Val, 'YYYYMMDD')::INT AS DATE_SK,
    Date_Val AS FULL_DATE,
    YEAR(Date_Val) AS YEAR,
    MONTH(Date_Val) AS MONTH,
    DAY(Date_Val) AS DAY,
    -- Manual mapping of the 7 abbreviated values
    CASE DAYNAME(Date_Val)
        WHEN 'Mon' THEN 'Monday'
        WHEN 'Tue' THEN 'Tuesday'
        WHEN 'Wed' THEN 'Wednesday'
        WHEN 'Thu' THEN 'Thursday'
        WHEN 'Fri' THEN 'Friday'
        WHEN 'Sat' THEN 'Saturday'
        WHEN 'Sun' THEN 'Sunday'
    END AS DAY_OF_WEEK,
    CASE 
        WHEN DAYOFWEEK(Date_Val) IN (0, 6) THEN 1 
        ELSE 0 
    END AS IS_WEEKEND
FROM Dates
WHERE Date_Val <= '2026-12-31'::DATE
ORDER BY DATE_SK