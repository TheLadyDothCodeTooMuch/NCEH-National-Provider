USE NCEH_Clinical_Operations_2026

-- Create the actual schema if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
END
GO

-- Transfer the table from dbo to the real bronze schema
-- Use the brackets exactly as they appear in the error/view
ALTER SCHEMA bronze TRANSFER dbo.[bronze.cms_doctor_info];
ALTER SCHEMA bronze TRANSFER dbo.[bronze.cms_facility_info];
ALTER SCHEMA bronze TRANSFER dbo.[bronze.cms_general_payments];
ALTER SCHEMA bronze TRANSFER dbo.[bronze.cms_hospital_rating];
ALTER SCHEMA bronze TRANSFER dbo.[bronze.cms_ownership_payments];
ALTER SCHEMA bronze TRANSFER dbo.[bronze.cms_providers_and_services];
ALTER SCHEMA bronze TRANSFER dbo.[bronze.cms_rbcs_taxonomy];
ALTER SCHEMA bronze TRANSFER dbo.[bronze.cms_research_payments];
GO

-- Rename it to remove the redundant 'bronze.' from the string name
EXEC sp_rename 'bronze.[bronze.cms_doctor_info]', 'cms_doctor_info';
EXEC sp_rename 'bronze.[bronze.cms_facility_info]', 'cms_facility_info';
EXEC sp_rename 'bronze.[bronze.cms_general_payments]', 'cms_general_payments';
EXEC sp_rename 'bronze.[bronze.cms_hospital_rating]', 'cms_hospital_rating';
EXEC sp_rename 'bronze.[bronze.cms_ownership_payments]', 'cms_ownership_payments';
EXEC sp_rename 'bronze.[bronze.cms_providers_and_services]', 'cms_providers_and_services';
EXEC sp_rename 'bronze.[bronze.cms_rbcs_taxonomy]', 'cms_rbcs_taxonomy';
EXEC sp_rename 'bronze.[bronze.cms_research_payments]', 'cms_research_payments';


-- rename row_id to row_key
EXEC sp_rename 'silver.cms_doctor_info_static.row_id', 'row_key', 'COLUMN';
EXEC sp_rename 'silver.cms_doctor_info_dynamic.row_id', 'row_key', 'COLUMN';
EXEC sp_rename 'silver.cms_facility_info.Row_Id', 'row_key', 'COLUMN';
EXEC sp_rename 'silver.cms_providers_and_services.Row_Id', 'row_key', 'COLUMN';
EXEC sp_rename 'silver.cms_hospital_rating.Row_Id', 'row_key', 'COLUMN';
EXEC sp_rename 'silver.cms_rbcs_taxonomy.Row_Id', 'row_key', 'COLUMN';
EXEC sp_rename 'silver.cms_general_payments.Row_Id', 'row_key', 'COLUMN';
EXEC sp_rename 'silver.cms_research_payments.Row_Id', 'row_key', 'COLUMN';
EXEC sp_rename 'silver.cms_ownership_payments.Row_Id', 'row_key', 'COLUMN';


-- silver.cms_doctor_info_static
EXEC sp_rename 'silver.cms_doctor_info_static.gender', 'provider_gender', 'COLUMN';
EXEC sp_rename 'silver.cms_doctor_info_static.is_ind_medicare_approved', 'is_prov_medicare_approved', 'COLUMN';


-- silver.cms_doctor_info_dynamic
EXEC sp_rename 'silver.cms_doctor_info_dynamic.individual_pac_id', 'provider_pac_id', 'COLUMN';
EXEC sp_rename 'silver.cms_doctor_info_dynamic.individual_enrollment_id', 'provider_enrollment_id', 'COLUMN';
EXEC sp_rename 'silver.cms_doctor_info_dynamic.pri_spec', 'primary_specialty', 'COLUMN';
EXEC sp_rename 'silver.cms_doctor_info_dynamic.group_pac_id', 'org_pac_id', 'COLUMN';
EXEC sp_rename 'silver.cms_doctor_info_dynamic.num_org_mem', 'org_member_count', 'COLUMN';
EXEC sp_rename 'silver.cms_doctor_info_dynamic.individual_city', 'provider_city', 'COLUMN';
EXEC sp_rename 'silver.cms_doctor_info_dynamic.individual_state', 'provider_state', 'COLUMN';
EXEC sp_rename 'silver.cms_doctor_info_dynamic.is_ind_medicare_approved', 'is_prov_medicare_approved', 'COLUMN';
EXEC sp_rename 'silver.cms_doctor_info_dynamic.is_group_medicare_approved', 'is_org_medicare_approved', 'COLUMN';
EXEC sp_rename 'silver.cms_doctor_info_dynamic.address_id', 'org_address_id', 'COLUMN';



-- silver.cms_facility_info
EXEC sp_rename 'silver.cms_facility_info.individual_pac_id', 'provider_pac_id', 'COLUMN';
EXEC sp_rename 'silver.cms_facility_info.facility_affiliations_certification_number', 'facility_id', 'COLUMN';


-- silver.cms_providers_and_services
EXEC sp_rename 'silver.cms_providers_and_services.hcpcs_cd', 'hcpcs_code', 'COLUMN';
EXEC sp_rename 'silver.cms_providers_and_services.hcpcs_desc', 'hcpcs_description', 'COLUMN';
EXEC sp_rename 'silver.cms_providers_and_services.hcpcs_drug_ind', 'is_drug_hcpc', 'COLUMN';
EXEC sp_rename 'silver.cms_providers_and_services.place_of_srvc', 'place_of_service', 'COLUMN';
EXEC sp_rename 'silver.cms_providers_and_services.tot_benes', 'unique_patient_count', 'COLUMN';
EXEC sp_rename 'silver.cms_providers_and_services.tot_srvcs', 'total_service_count', 'COLUMN';
EXEC sp_rename 'silver.cms_providers_and_services.tot_bene_day_srvcs', 'distinct_service_days', 'COLUMN';
EXEC sp_rename 'silver.cms_providers_and_services.avg_sbmtd_chrg', 'average_provider_charge', 'COLUMN';
EXEC sp_rename 'silver.cms_providers_and_services.average_medicare_allowed_amount', 'average_medicare_allowed', 'COLUMN';
EXEC sp_rename 'silver.cms_providers_and_services.average_medicare_payment_amount', 'average_medicare_payment', 'COLUMN';
EXEC sp_rename 'silver.cms_providers_and_services.average_medicare_standardized_payment_amount', 'average_medicare_standardized', 'COLUMN';


-- silver.cms_hospital_rating
EXEC sp_rename 'silver.cms_hospital_rating.address', 'facility_address', 'COLUMN';
EXEC sp_rename 'silver.cms_hospital_rating.city', 'facility_city', 'COLUMN';
EXEC sp_rename 'silver.cms_hospital_rating.state', 'facility_state', 'COLUMN';
EXEC sp_rename 'silver.cms_hospital_rating.emergency_services', 'has_emergency_services', 'COLUMN';


-- silver.cms_rbcs_taxonomy
EXEC sp_rename 'silver.cms_rbcs_taxonomy.hcpcs_cd', 'hcpcs_code', 'COLUMN';
EXEC sp_rename 'silver.cms_rbcs_taxonomy.rbcs_cat_desc', 'rbcs_category_description', 'COLUMN';
EXEC sp_rename 'silver.cms_rbcs_taxonomy.rbcs_subcat_desc', 'rbcs_subcategory_description', 'COLUMN';
EXEC sp_rename 'silver.cms_rbcs_taxonomy.rbcs_family_desc', 'rbcs_family_description', 'COLUMN';


-- silver.cms_general_payments
EXEC sp_rename 'silver.cms_general_payments.covered_recipient_npi', 'npi', 'COLUMN';
EXEC sp_rename 'silver.cms_general_payments.recipient_city', 'provider_city', 'COLUMN';
EXEC sp_rename 'silver.cms_general_payments.recipient_state', 'provider_state', 'COLUMN';
EXEC sp_rename 'silver.cms_general_payments.total_amount_of_payment_usdollars', 'payment_amount', 'COLUMN';
EXEC sp_rename 'silver.cms_general_payments.date_of_payment', 'payment_date', 'COLUMN';
EXEC sp_rename 'silver.cms_general_payments.nature_of_payment_or_transfer_of_value', 'payment_nature', 'COLUMN';
EXEC sp_rename 'silver.cms_general_payments.applicable_manufacturer_or_applicable_gpo_making_payment_name', 'payer_name', 'COLUMN';
EXEC sp_rename 'silver.cms_general_payments.name_of_drug_or_biological_or_device_or_medical_supply', 'product_name', 'COLUMN';


-- silver.cms_research_payments
EXEC sp_rename 'silver.cms_research_payments.principal_investigator_npi', 'npi', 'COLUMN';
EXEC sp_rename 'silver.cms_research_payments.submitting_applicable_manufacturer_or_applicable_gpo_name', 'submitting_payer_name', 'COLUMN';
EXEC sp_rename 'silver.cms_research_payments.applicable_manufacturer_or_applicable_gpo_making_payment_id', 'payer_id', 'COLUMN';
EXEC sp_rename 'silver.cms_research_payments.applicable_manufacturer_or_applicable_gpo_making_payment_name', 'payer_name', 'COLUMN';
EXEC sp_rename 'silver.cms_research_payments.indicate_drug_or_biological_or_device_or_medical_supply', 'product_type', 'COLUMN';
EXEC sp_rename 'silver.cms_research_payments.name_of_drug_or_biological_or_device_or_medical_supply', 'product_name', 'COLUMN';
EXEC sp_rename 'silver.cms_research_payments.total_amount_of_payment_usdollars', 'payment_amount', 'COLUMN';
EXEC sp_rename 'silver.cms_research_payments.date_of_payment', 'payment_date', 'COLUMN';
EXEC sp_rename 'silver.cms_research_payments.form_of_payment_or_transfer_of_value', 'payment_form', 'COLUMN';


-- silver.cms_ownership_payments
EXEC sp_rename 'silver.cms_ownership_payments.physician_npi', 'npi', 'COLUMN';
EXEC sp_rename 'silver.cms_ownership_payments.recipient_city', 'provider_city', 'COLUMN';
EXEC sp_rename 'silver.cms_ownership_payments.recipient_state', 'provider_state', 'COLUMN';
EXEC sp_rename 'silver.cms_ownership_payments.physician_primary_type', 'provider_primary_type', 'COLUMN';
EXEC sp_rename 'silver.cms_ownership_payments.total_amount_invested_usdollars', 'investment_amount', 'COLUMN';
EXEC sp_rename 'silver.cms_ownership_payments.value_of_interest', 'interest_value', 'COLUMN';
EXEC sp_rename 'silver.cms_ownership_payments.terms_of_interest', 'interest_terms', 'COLUMN';
EXEC sp_rename 'silver.cms_ownership_payments.submitting_applicable_manufacturer_or_applicable_gpo_name', 'submitting_payer_name', 'COLUMN';
EXEC sp_rename 'silver.cms_ownership_payments.applicable_manufacturer_or_applicable_gpo_making_payment_id', 'payer_id', 'COLUMN';
EXEC sp_rename 'silver.cms_ownership_payments.applicable_manufacturer_or_applicable_gpo_making_payment_name', 'payer_name', 'COLUMN';
EXEC sp_rename 'silver.cms_ownership_payments.interest_held_by_physician_or_an_immediate_family_member', 'interest_holder', 'COLUMN';


-- rename silver.cms_facility_info to silver.cms_facility_affiliation (ERRONEOUS!)
EXEC sp_rename 'silver.cms_facility_info', 'silver.cms_facility_affiliation';
EXEC sp_rename 'bronze.cms_facility_info', 'bronze.cms_facility_affiliations';

-- Fix the Silver table (to correct the above error)
EXEC sp_rename 'silver."silver.cms_facility_affiliation"', 'cms_facility_affiliations';
EXEC sp_rename 'bronze."bronze.cms_facility_affiliations"', 'cms_facility_affiliations';

-- the right way to rename tables
-- EXEC sp_rename 'silver.cms_facility_affiliation', 'cms_facility_affiliations';
-- EXEC sp_rename 'bronze.cms_facility_affiliations', 'cms_facility_affiliations';