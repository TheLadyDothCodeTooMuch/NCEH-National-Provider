USE NCEH_Clinical_Operations_2026

SELECT
    'cms_doctor_info.csv' AS table_name,
    COUNT (*) AS 'count'
FROM bronze.cms_doctor_info
UNION
SELECT
    'cms_facility_affiliations.csv' AS table_name,
    COUNT (*) AS 'count'
FROM bronze.cms_facility_affiliations
UNION
-- SELECT
--     'cms_providers_and_services.csv' AS table_name,
--     COUNT (*) AS 'count'
-- FROM bronze.cms_providers_and_services
-- UNION
SELECT
    'cms_hospital_rating.csv' AS table_name,
    COUNT (*) AS 'count'
FROM bronze.cms_hospital_rating
UNION
SELECT
    'cms_rbcs_taxonomy.csv' AS table_name,
    COUNT (*) AS 'count'
FROM bronze.cms_rbcs_taxonomy
UNION
SELECT
    'cms_general_payments.csv' AS table_name,
    COUNT (*) AS 'count'
FROM bronze.cms_general_payments
UNION
SELECT
    'cms_research_payments.csv' AS table_name,
    COUNT (*) AS 'count'
FROM bronze.cms_research_payments
UNION
SELECT
    'cms_ownership_payments.csv' AS table_name,
    COUNT (*) AS 'count'
FROM bronze.cms_ownership_payments
UNION
SELECT
    'cms_asc_codes.csv' AS table_name,
    COUNT (*) AS 'count'
FROM bronze.cms_asc_codes
UNION
SELECT
    'cms_facility_info.csv' AS table_name,
    COUNT (*) AS 'count'
FROM bronze.cms_facility_info
;

-- cms_doctor_info.csv has 2,819,129 rows pre-SQL load
-- cms_facility_affiliations.csv has 1,623,829 rows pre-SQL load
-- cms_providers_and_services.csv has 9,660,647 rows pre-SQL load
-- cms_hospital_rating.csv has 5,426 rows pre-SQL load
-- cms_rbcs_taxonomy.csv has 18,882 rows pre-SQL load
-- cms_general_payments.csv has 14,700,807 rows pre-SQL load
-- cms_research_payments.csv has 1,079,799 rows pre-SQL load
-- cms_ownership_payments.csv has 4,448 rows pre-SQL load
-- cms_asc_codes.csv has 9,695 rows pre-SQL load
-- cms_facility_info.csv has 9,182 rows pre-SQL load

-- check if the ID columns are null
SELECT 
    *
FROM bronze.cms_facility_info
WHERE [ENROLLMENT ID] IS NULL OR [ENROLLMENT ID] IN ('', ' ') OR
        NPI IS NULL OR NPI IN ('', ' ') OR
        CCN IS NULL OR CCN IN ('', ' ') OR
        [ASSOCIATE ID] IS NULL OR [ASSOCIATE ID] IN ('', ' ')
    -- Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID IS NULL
;

-- check if the amount columns are null
SELECT 
    *
FROM silver.cms_asc_codes
WHERE payment_rate IS NULL OR 
    payment_weight IS NULL 
    -- OR 
--     avg_mdcr_pymt_amt IS NULL OR
--     avg_mdcr_stdzd_amt IS NULL
-- ;


-- check to see the actual total of columns with null ID values
SELECT
    COUNT(*)
FROM silver.cms_asc_codes
WHERE payment_weight IS NULL;


-- check if the facility number will change to an int. If not, we get the number from the type number column
SELECT
    --COUNT(*)
    *
FROM bronze.cms_facility_info
WHERE TRY_CAST(CCN AS int) IS NULL;


-- check to know the actual count of null values for the name columns
SELECT 
    COUNT(*)
FROM silver.cms_asc_codes
WHERE hcpcs_description IS NULL
;


-- check to know the null values for the date columns
SELECT 
    Payment_Publication_Date
FROM bronze.cms_ownership_payments
WHERE Payment_Publication_Date IS NULL
;


-- check if the ID column (to be the PK)  contains duplicate values
SELECT
	[ASSOCIATE ID],
	COUNT(*) AS count_duplicate
FROM bronze.cms_facility_info
GROUP BY [ASSOCIATE ID]
HAVING COUNT(*) > 1

-- show the original and duplicates
WITH duplicates AS (
	SELECT
        [ENROLLMENT ID],
        NPI,
        CCN,
        [ASSOCIATE ID],
        [ORGANIZATION NAME],
        [DOING BUSINESS AS NAME],
        [ORGANIZATION TYPE STRUCTURE],
        [PROPRIETARY NONPROFIT],
        [ADDRESS LINE 1],
        CITY,
        [STATE],
		COUNT(*) OVER(PARTITION BY [ASSOCIATE ID]) AS count_duplicate
	FROM bronze.cms_facility_info
)
SELECT
	*
FROM duplicates
WHERE count_duplicate > 1
ORDER BY [ASSOCIATE ID] ASC


-- check if the descriptive columns (first name, last, name, gendr, pri_spec, facility name etc) are blank
SELECT 
    COUNT(*)
FROM bronze.cms_facility_info
WHERE [ORGANIZATION NAME] IN ('', ' ') OR [ORGANIZATION NAME] IS NULL OR
    [DOING BUSINESS AS NAME] IN ('', ' ') OR [DOING BUSINESS AS NAME] IS NULL OR
    [ORGANIZATION TYPE STRUCTURE] IN ('', ' ') OR [ORGANIZATION TYPE STRUCTURE] IS NULL OR
    [PROPRIETARY NONPROFIT] IN ('', ' ') OR [PROPRIETARY NONPROFIT] IS NULL OR
    [ADDRESS LINE 1] IN ('', ' ') OR [ADDRESS LINE 1] IS NULL OR
    [ADDRESS LINE 1] IN ('', ' ') OR [ADDRESS LINE 1] IS NULL OR
    [STATE] IN ('', ' ') OR [STATE] IS NULL 
;


SELECT 
    [ENROLLMENT ID],
    NPI,
    CCN,
    [ORGANIZATION NAME],
    [DOING BUSINESS AS NAME],
    [ORGANIZATION TYPE STRUCTURE],
    [PROPRIETARY NONPROFIT],
    [ADDRESS LINE 1],
    CITY,
    [STATE],
    [SUBGROUP - ACUTE CARE]
FROM bronze.cms_facility_info
WHERE [ORGANIZATION NAME] IN ('', ' ') OR [ORGANIZATION NAME] IS NULL OR
    -- [DOING BUSINESS AS NAME] IN ('', ' ') OR [DOING BUSINESS AS NAME] IS NULL OR
    [ORGANIZATION TYPE STRUCTURE] IN ('', ' ') OR [ORGANIZATION TYPE STRUCTURE] IS NULL OR
    [PROPRIETARY NONPROFIT] IN ('', ' ') OR [PROPRIETARY NONPROFIT] IS NULL OR
    [ADDRESS LINE 1] IN ('', ' ') OR [ADDRESS LINE 1] IS NULL OR
    [ADDRESS LINE 1] IN ('', ' ') OR [ADDRESS LINE 1] IS NULL OR
    [STATE] IN ('', ' ') OR [STATE] IS NULL 
;

SELECT 
    COUNT(*)
FROM bronze.cms_asc_codes
WHERE [Short Descriptor] IN ('', ' ') OR [Short Descriptor] IS NULL
    -- Recipient_State IN ('', ' ') OR Recipient_State IS NULL OR
    -- Physician_Primary_Type IN ('', ' ') OR Physician_Primary_Type IS NULL OR
    -- Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name IN ('', ' ') OR Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name IS NULL OR
    -- Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name IN ('', ' ') OR Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name IS NULL OR
    -- Physician_Specialty IN ('', ' ') OR Physician_Specialty IS NULL 
;


-- check if ID columns are unique
SELECT
    DISTINCT [City/Town],
    [State],
    COUNT([Facility ID]) AS Count_of_Facilities
FROM bronze.cms_hospital_rating
-- WHERE [City/Town] LIKE '%WAS%'
WHERE [State] = 'DC'
GROUP BY [City/Town],
    [State]


SELECT
    COUNT(DISTINCT [SUBGROUP - ACUTE CARE])
FROM bronze.cms_facility_info;


-- to find out how long the column values are. I also used the data dictionary to inform the length used
SELECT
    MAX(LEN([SUBGROUP - ACUTE CARE]))
FROM bronze.cms_facility_info
;


SELECT 
    COUNT(Recipient_City),
    COUNT(Recipient_State)
FROM bronze.cms_ownership_payments
WHERE Recipient_City IS NULL OR Recipient_City IN ('', ' ') 
OR Recipient_State IS NULL OR Recipient_State IN ('', ' ') 
-- OR org_pac_id IS NULL
;


-- checking how many distinct categories are in a category column
SELECT DISTINCT
    [SUBGROUP - ACUTE CARE]
FROM bronze.cms_facility_info
ORDER BY 1 ASC
;


-- checking if the payment dates are within reason (i.e 2023)
SELECT
    Payment_Publication_Date
FROM bronze.cms_ownership_payments
WHERE YEAR(Payment_Publication_Date) > 2023 OR YEAR(Payment_Publication_Date) < 2023
ORDER BY Payment_Publication_Date ASC
;


SELECT
    COUNT(*)
FROM bronze.cms_ownership_payments
WHERE YEAR(Payment_Publication_Date) = 2023
;


SELECT TOP 10
    YEAR(Payment_Publication_Date)
FROM bronze.cms_ownership_payments
-- WHERE YEAR(Payment_Publication_Date) = 2023
;


SELECT
    COUNT(*)
FROM bronze.cms_ownership_payments
;


-- checking if the facility affiliations number is now all integers
SELECT
    *
FROM silver.cms_facility_affiliations
WHERE npi = '1003001371' AND ind_pac_id = '4385734086'


WITH ranking AS (
    SELECT
        hcpcs_cd,
        rbcs_cat_desc, 
        rbcs_subcat_desc, 
        rbcs_family_desc,
        ROW_NUMBER() OVER(PARTITION BY hcpcs_cd ORDER BY hcpcs_cd ASC) AS cd_ranking
    FROM silver.cms_rbcs_taxonomy)
SELECT
    hcpcs_cd,
    rbcs_cat_desc, 
    rbcs_subcat_desc, 
    rbcs_family_desc
FROM ranking
WHERE hcpcs_cd = '0209T'


WITH ranking AS (
    SELECT
        hcpcs_cd,
        rbcs_cat_desc, 
        rbcs_subcat_desc, 
        rbcs_family_desc,
        ROW_NUMBER() OVER(PARTITION BY hcpcs_cd ORDER BY hcpcs_cd ASC) AS cd_ranking
    FROM silver.cms_rbcs_taxonomy)
SELECT TOP 1000
    hcpcs_cd,
    rbcs_cat_desc, 
    rbcs_subcat_desc, 
    rbcs_family_desc,
    cd_ranking
FROM ranking
WHERE cd_ranking > 1
ORDER BY 1 ASC, 5 DESC


SELECT
    COUNT(DISTINCT hcpcs_cd)
FROM silver.cms_rbcs_taxonomy


SELECT DISTINCT
    [PROPRIETARY NONPROFIT]
FROM bronze.cms_facility_info
-- ORDER BY 1
-- WHERE rbcs_cat_desc LIKE '%Test%'

SELECT DISTINCT
    [ORGANIZATION TYPE STRUCTURE]
FROM bronze.cms_facility_info
-- ORDER BY 1
-- WHERE rbcs_cat_desc LIKE '%Other%';


SELECT
    *
FROM bronze.cms_facility_info
WHERE [PROPRIETARY NONPROFIT] = 'D'


SELECT
    *
FROM bronze.cms_ownership_payments
WHERE Total_Amount_Invested_USDollars = (
    SELECT
        MAX(Total_Amount_Invested_USDollars)
    FROM bronze.cms_ownership_payments
)


---
SELECT name AS AuditName, 
       log_file_path AS [Audit File Path] 
FROM sys.server_file_audits;


SELECT *
FROM sys.server_file_audits;


SELECT 
    MAX(Total_Amount_of_Payment_USDollars)
FROM bronze.cms_research_payments
WHERE Principal_Investigator_1_NPI IS NULL OR
    -- tot_benes IS NULL OR 
    -- tot_srvcs IS NULL OR
    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID IS NULL
;


SELECT 
    COUNT([state])
FROM silver.cms_hospital_rating
WHERE [state] = 'DC'


SELECT
    DISTINCT applicable_manufacturer_or_applicable_gpo_making_payment_name
FROM silver.cms_ownership_payments
ORDER BY 1 ASC


SELECT
    DISTINCT applicable_manufacturer_or_applicable_gpo_making_payment_name
FROM silver.cms_general_payments
ORDER BY 1 ASC


SELECT
    COUNT(DISTINCT applicable_manufacturer_or_applicable_gpo_making_payment_id) AS ID,
    COUNT(DISTINCT applicable_manufacturer_or_applicable_gpo_making_payment_name) AS NAME
FROM silver.cms_research_payments



SELECT
    COUNT(*)
FROM silver.cms_facility_affiliations




SELECT  
    COUNT(DISTINCT facility_id) AS unique_no_of_npi
FROM silver.cms_facility_affiliations
;

--vs

SELECT
    COUNT(facility_id) AS no_of_npi
FROM silver.cms_facility_affiliations
;