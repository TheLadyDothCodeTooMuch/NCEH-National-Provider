CREATE SCHEMA bronze
GO

CREATE SCHEMA silver
GO

IF NOT EXISTS(SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold')
END
GO

SELECT * FROM sys.schemas

SELECT 
DISTINCT CATALOG_NAME 
FROM INFORMATION_SCHEMA.SCHEMATA


SELECT 
*
FROM INFORMATION_SCHEMA.TABLES

SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA;


SELECT * FROM sys.databases;
SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA;


SELECT
  t.name                                     AS table_name,
  SUM(p.rows)                                AS row_count
FROM sys.tables t
JOIN sys.partitions p
  ON t.object_id = p.object_id
WHERE p.index_id IN (0, 1)
GROUP BY t.name
ORDER BY row_count DESC;


WITH duplicate_rows AS (
SELECT
	npi,
	COUNT(*) OVER(PARTITION BY npi) AS total_entries,
	ROW_NUMBER() OVER(PARTITION BY npi ORDER BY npi) AS ranking
FROM silver.cms_doctor_info_dynamic
)
SELECT
	npi,
	total_entries
FROM duplicate_rows
WHERE ranking > 1
