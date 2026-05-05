USE NCEH_Clinical_Operations_2026

CREATE TABLE silver.cms_doctor_info_static (
	row_id INT IDENTITY(1,1) PRIMARY KEY,
	npi bigint,
	provider_first_name NVARCHAR(25) NULL,
	provider_last_name NVARCHAR(35) NULL,
	gndr NVARCHAR(1) NULL,
	ind_assgn NVARCHAR(1) NULL,
	create_date DATETIME2 DEFAULT GETDATE(),
	CONSTRAINT UQ_NPI UNIQUE (npi)
) 


CREATE TABLE silver.cms_doctor_info_dynamic (
	row_id INT IDENTITY(1,1) PRIMARY KEY,
	npi NVARCHAR(10),
	ind_pac_id bigint NULL,
	ind_enrl_id NVARCHAR(15) NULL,
	pri_spec NVARCHAR(60) NULL,
	facility_name NVARCHAR(70) NULL,
	org_pac_id FLOAT NULL,
	num_org_mem NVARCHAR(8) NULL,
	city NVARCHAR(30) NULL,
	state NVARCHAR(2) NULL,
	ind_assgn NVARCHAR(1) NULL,
	grp_assgn NVARCHAR(1) NULL,
	adrs_id NVARCHAR(25) NULL,
	create_date DATETIME2 DEFAULT GETDATE()
) 

-- create index on npi to make the joins faster
CREATE NONCLUSTERED INDEX idx_dynamic_npi ON silver.cms_doctor_info_dynamic(npi);


CREATE TABLE silver.cms_facility_info (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    npi NVARCHAR(10),
    ind_pac_id NVARCHAR(10),
    facility_type NVARCHAR(40),
    facility_affiliations_certification_number NVARCHAR(6),
    create_date DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE silver.cms_providers_and_services (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    npi INT,
    hcpcs_cd NVARCHAR(10),
    hcpcs_desc NVARCHAR(300),
    hcpcs_drug_ind NVARCHAR(1),
    place_of_srvc NVARCHAR(1),
    tot_benes INT,
    tot_srvcs INT,
    tot_bene_day_srvcs INT,
    avg_sbmtd_chrg DECIMAL(10,3),
    avg_mdcr_alowd_amt DECIMAL(10,3),
    avg_mdcr_pymt_amt DECIMAL(10,3), 
    avg_mdcr_stdzd_amt DECIMAL(10,3),
    create_date DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE silver.cms_hospital_rating (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    facility_id NVARCHAR(200),
    facility_name NVARCHAR(200),
    address NVARCHAR(200),
    city NVARCHAR(200),
    state NVARCHAR(200),
    hospital_type NVARCHAR(200),
    hospital_ownership NVARCHAR(200),
    emergency_services NVARCHAR(200),
    hospital_overall_rating NVARCHAR(200),
    create_date DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE silver.cms_rbcs_taxonomy (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    hcpcs_cd  NVARCHAR(6), 
    rbcs_cat_desc NVARCHAR(10), 
    rbcs_subcat_desc NVARCHAR(45), 
    rbcs_family_desc NVARCHAR(60),
    create_date DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE silver.cms_general_payments (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    covered_recipient_npi DECIMAL(12,0),
    recipient_city NVARCHAR(40),
    recipient_state NVARCHAR(40),
    total_amount_of_payment_usdollars DECIMAL(12,3),
    date_of_payment DATETIME2,
    nature_of_payment_or_transfer_of_value NVARCHAR(200),
    applicable_manufacturer_or_applicable_gpo_making_payment_name NVARCHAR(100),
    name_of_drug_or_biological_or_device_or_medical_supply NVARCHAR(200),
    create_date DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE silver.cms_research_payments (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    principal_investigator_npi DECIMAL(12,0),
    principal_investigator_city NVARCHAR(50),
    principal_investigator_state NVARCHAR(13),
    principal_investigator_primary_type NVARCHAR(200),
    principal_investigator_specialty NVARCHAR(200),
    submitting_applicable_manufacturer_or_applicable_gpo_name NVARCHAR(100),
    applicable_manufacturer_or_applicable_gpo_making_payment_id DECIMAL(12,0),
    applicable_manufacturer_or_applicable_gpo_making_payment_name NVARCHAR(200),
    indicate_drug_or_biological_or_device_or_medical_supply NVARCHAR(20),
    name_of_drug_or_biological_or_device_or_medical_supply NVARCHAR(100),
    total_amount_of_payment_usdollars DECIMAL(12,3),
    date_of_payment DATETIME2,
    form_of_payment_or_transfer_of_value NVARCHAR(60),
    create_date DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE silver.cms_ownership_payments (
    Row_ID INT IDENTITY(1,1) PRIMARY KEY,
    physician_npi DECIMAL(12,0),
    recipient_city NVARCHAR(22),
    recipient_state NVARCHAR(20),
    physician_primary_type NVARCHAR(30),
    physician_specialty NVARCHAR(120),
    total_amount_invested_usdollars DECIMAL(12,3),
    value_of_interest DECIMAL(12,3),
    terms_of_interest NVARCHAR(550),
    submitting_applicable_manufacturer_or_applicable_gpo_name NVARCHAR(60),
    applicable_manufacturer_or_applicable_gpo_making_payment_id NVARCHAR(20),
    applicable_manufacturer_or_applicable_gpo_making_payment_name NVARCHAR(60),
    interest_held_by_physician_or_an_immediate_family_member NVARCHAR(30),
    payment_publication_date DATETIME2,
    contains_npi NVARCHAR(1),
    create_date DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE silver.cms_asc_codes (
    Row_ID INT IDENTITY(1,1),
    hcpcs_code NVARCHAR(10) PRIMARY KEY,
    hcpcs_description NVARCHAR(100),
    is_discountable NVARCHAR(2),
    payment_indicator NVARCHAR(2),
    payment_weight DECIMAL(8,4),
    payment_rate DECIMAL(8,2)
);


CREATE TABLE silver.cms_facility_info (
    facility_enrollment_id NVARCHAR(15) NOT NULL,
    facility_npi VARCHAR(10) NOT NULL,
    facility_ccn NVARCHAR(9) PRIMARY KEY NOT NULL,
    facility_legal_name NVARCHAR(100) NOT NULL,
    facility_business_name NVARCHAR(100) NOT NULL,
    facility_entity_type NVARCHAR(15),
    facility_ownership_type NVARCHAR(20),
    facility_address NVARCHAR(100),
    facility_city NVARCHAR(50) NOT NULL,
    facility_state NVARCHAR(2) NOT NULL,
    is_acute_care_facility NVARCHAR(10)
)


