USE NCEH_Clinical_Operations_2026

CREATE TABLE bronze.cms_doctor_info (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    NPI INT,
    Ind_PAC_ID INT,
    Ind_enrl_ID NVARCHAR(15),
    [Provider Last Name] NVARCHAR(35),
    [Provider First Name] NVARCHAR(25),
    gndr NVARCHAR(1),
    pri_spec NVARCHAR(60),
    [Facility Name] NVARCHAR(70),
    org_pac_id NVARCHAR(10),
    num_org_mem INT,
    [City/Town] NVARCHAR(30),
    State NVARCHAR(2),
    ind_assgn NVARCHAR(1),
    grp_assgn NVARCHAR(1),
    adrs_id NVARCHAR(25),
    create_date DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE bronze.cms_facility_info (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    NPI INT,
    Ind_PAC_ID INT,
    facility_type NVARCHAR(40),
    [Facility Affiliations Certification Number] NVARCHAR(6),
    [Facility Type Certification Number] NVARCHAR(6),
    create_date DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE bronze.cms_providers_and_services (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    Rndrng_NPI INT,
    HCPCS_Cd NVARCHAR(10),
    HCPCS_Desc NVARCHAR(300),
    HCPCS_Drug_Ind NVARCHAR(1),
    Place_Of_Srvc NVARCHAR(1),
    Tot_Benes INT,
    Tot_Srvcs INT,
    Tot_Bene_Day_Srvcs DECIMAL(10,3),
    Avg_Sbmtd_Chrg DECIMAL(10,3),
    Avg_Mdcr_Alowd_Amt DECIMAL(10,3),
    Avg_Mdcr_Pymt_Amt DECIMAL(10,3), 
    Avg_Mdcr_Stdzd_Amt DECIMAL(10,3),
    create_date DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE bronze.cms_hospital_rating (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    [Facility ID] NVARCHAR(200),
    [Facility Name] NVARCHAR(200),
    Address NVARCHAR(200),
    [City/Town] NVARCHAR(200),
    State NVARCHAR(200),
    [Hospital Type] NVARCHAR(200),
    [Hospital Ownership] NVARCHAR(200),
    [Emergency Services] NVARCHAR(200),
    [Hospital overall rating] NVARCHAR(200),
    [Hospital overall rating footnote] NVARCHAR(200),
    create_date DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE bronze.cms_rbcs_taxonomy (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    HCPCS_Cd  NVARCHAR(200), 
    RBCS_Cat_Desc NVARCHAR(200), 
    RBCS_Subcat_Desc NVARCHAR(200), 
    RBCS_Family_Desc NVARCHAR(200),
    create_date DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE bronze.cms_general_payments (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    Covered_Recipient_NPI NVARCHAR(30),
    Recipient_City NVARCHAR(50),
    Recipient_State NVARCHAR(10),
    Total_Amount_of_Payment_USDollars NVARCHAR(200),
    Date_of_Payment DATETIME2,
    Nature_of_Payment_or_Transfer_of_Value NVARCHAR(200),
    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name NVARCHAR(400),
    Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1 NVARCHAR(200),
    create_date DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE bronze.cms_research_payments (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    Principal_Investigator_1_NPI NVARCHAR(30),
    Principal_Investigator_1_City NVARCHAR(30),
    Principal_Investigator_1_State NVARCHAR(13),
    Principal_Investigator_1_Primary_Type_1 NVARCHAR(40),
    Principal_Investigator_1_Specialty_1 NVARCHAR(200),
    Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name NVARCHAR(100),
    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID NVARCHAR(30),
    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name NVARCHAR(200),
    Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 NVARCHAR(20),
    Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1 NVARCHAR(200),
    Total_Amount_of_Payment_USDollars DECIMAL(8,3),
    Date_of_Payment DATETIME2,
    Form_of_Payment_or_Transfer_of_Value NVARCHAR(200),
    create_date DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE bronze.cms_ownership_payments (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    Physician_NPI NVARCHAR(30),
    Recipient_City NVARCHAR(50),
    Recipient_State NVARCHAR(10),
    Physician_Primary_Type NVARCHAR(200),
    Physician_Specialty NVARCHAR(200),
    Total_Amount_Invested_USDollars DECIMAL(8,3),
    Value_of_Interest DECIMAL(8,3),
    Terms_of_Interest NVARCHAR(200),
    Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name NVARCHAR(200),
    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID NVARCHAR(30),
    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name NVARCHAR(200),
    Interest_Held_by_Physician_or_an_Immediate_Family_Member NVARCHAR(200),
    Payment_Publication_Date DATETIME2,
    create_date DATETIME2 DEFAULT GETDATE()
);


SELECT * FROM INFORMATION_SCHEMA.COLUMNS 


DROP TABLE IF EXISTS bronze.cms_ownership_payments;
GO

CREATE TABLE bronze.cms_ownership_payments (
    Physician_NPI NVARCHAR(30),
    Recipient_City NVARCHAR(100), -- Increased from 50
    Recipient_State NVARCHAR(20), -- Increased from 10
    Physician_Primary_Type NVARCHAR(255),
    Physician_Specialty NVARCHAR(500), -- Increased from 200
    Total_Amount_Invested_USDollars DECIMAL(19,4), -- Handles billions
    Value_of_Interest DECIMAL(19,4),              -- Handles billions
    Terms_of_Interest NVARCHAR(MAX),               -- Safe from truncation
    Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name NVARCHAR(500),
    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID NVARCHAR(50),
    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name NVARCHAR(500),
    Interest_Held_by_Physician_or_an_Immediate_Family_Member NVARCHAR(500),
    Payment_Publication_Date DATETIME2
);


CREATE TABLE bronze.cms_asc_codes (
    [HCPCS Code] NVARCHAR(10),
    [Short Descriptor] NVARCHAR(100),
    [Subject to Multiple Procedure Discounting] NVARCHAR(2),
    [Proposed CY 2026 Payment Indicator] NVARCHAR(2),
    [Proposed CY 2026 Payment Weight] DECIMAL(8,4),
    [Proposed CY 2026 Payment Rate] DECIMAL(8,2)
);


CREATE TABLE bronze.cms_facility_info (
    [ENROLLMENT ID] NVARCHAR(15),
    NPI NVARCHAR(10),
    CCN NVARCHAR(10),
    [ASSOCIATE ID] NVARCHAR(10),
    [ORGANIZATION NAME] NVARCHAR(500),
    [DOING BUSINESS AS NAME] NVARCHAR(500),
    [ORGANIZATION TYPE STRUCTURE] NVARCHAR(200),
    [PROPRIETARY NONPROFIT] NVARCHAR(1),
    [ADDRESS LINE 1] NVARCHAR(500),
    CITY NVARCHAR(100),
    [STATE] NVARCHAR(10),
    [SUBGROUP - ACUTE CARE] NVARCHAR(10)
)

