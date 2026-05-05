USE NCEH_Clinical_Operations_2026

WITH unique_npi AS (
    SELECT 
        ROW_NUMBER() OVER(PARTITION BY NPI ORDER BY [Provider Last Name] DESC) AS row_rank,
        CAST(NPI AS VARCHAR(10)) AS NPI,
        [Provider First Name] AS first_name,
        [Provider Last Name] AS last_name,
        gndr,
        ind_assgn
    FROM bronze.cms_doctor_info
)
INSERT INTO silver.cms_doctor_info_static (npi, provider_first_name, provider_last_name, gndr, ind_assgn)
    SELECT
        NPI,
        first_name,
        last_name,
        gndr,
        ind_assgn
    FROM unique_npi
    WHERE row_rank = 1
    ORDER BY NPI ASC
;


INSERT INTO silver.cms_doctor_info_dynamic (npi, ind_pac_id, ind_enrl_id, pri_spec, facility_name, org_pac_id, num_org_mem, city, state, ind_assgn, grp_assgn, adrs_id)
    SELECT
        CAST(NPI AS VARCHAR(10)),
        CAST(Ind_PAC_ID AS VARCHAR(10)),
        Ind_enrl_ID,
        pri_spec,
        [Facility Name],
        CAST(org_pac_id AS float),
        num_org_mem,
        [City/Town],
        State,
        ind_assgn,
        grp_assgn,
        adrs_id
    FROM bronze.cms_doctor_info
    ORDER BY 1 ASC
;


INSERT INTO silver.cms_facility_info (npi, ind_pac_id, facility_type, facility_affiliations_certification_number)
    SELECT
        NPI,
        Ind_PAC_ID,
        facility_type,
        CASE
            WHEN TRY_CAST([Facility Affiliations Certification Number] AS int) IS NULL THEN [Facility Type Certification Number]
            ELSE [Facility Affiliations Certification Number]
        END
    FROM bronze.cms_facility_info 
    ORDER BY 1
;


INSERT INTO silver.cms_providers_and_services (npi, hcpcs_cd, hcpcs_desc, hcpcs_drug_ind, place_of_srvc, tot_benes, tot_srvcs, tot_bene_day_srvcs, avg_sbmtd_chrg, avg_mdcr_alowd_amt, avg_mdcr_pymt_amt, avg_mdcr_stdzd_amt)
    SELECT
        Rndrng_NPI,
        HCPCS_Cd,
        HCPCS_Desc,
        HCPCS_Drug_Ind,
        Place_Of_Srvc,
        Tot_Benes,
        Tot_Srvcs,
        Tot_Bene_Day_Srvcs,
        Avg_Sbmtd_Chrg,
        Avg_Mdcr_Alowd_Amt,
        Avg_Mdcr_Pymt_Amt, 
        Avg_Mdcr_Stdzd_Amt
    FROM bronze.cms_providers_and_services
    ORDER BY 1


INSERT INTO silver.cms_hospital_rating (facility_id, facility_name, address, city, state, hospital_type, hospital_ownership, emergency_services, hospital_overall_rating)
    SELECT
        [Facility ID],
        [Facility Name],
        Address,
        [City/Town],
        State,
        [Hospital Type],
        [Hospital Ownership],
        [Emergency Services],
        [Hospital overall rating]
    FROM bronze.cms_hospital_rating
    ORDER BY [Facility ID] ASC
;


WITH ranking AS (
    SELECT
        HCPCS_Cd,
        RBCS_Cat_Desc,
        RBCS_Subcat_Desc,
        RBCS_Family_Desc,
        ROW_NUMBER() OVER(PARTITION BY HCPCS_Cd 
            ORDER BY 
                CASE
                    WHEN HCPCS_Cd = 'Other' THEN 2
                    ELSE 1
                END ASC) AS cd_ranking
    FROM bronze.cms_rbcs_taxonomy)
INSERT INTO silver.cms_rbcs_taxonomy (hcpcs_cd, rbcs_cat_desc, rbcs_subcat_desc, rbcs_family_desc)
    SELECT
        HCPCS_Cd,
        RBCS_Cat_Desc,
        RBCS_Subcat_Desc,
        RBCS_Family_Desc
    FROM ranking
    WHERE cd_ranking = 1
    ORDER BY 1
;


INSERT INTO silver.cms_general_payments (covered_recipient_npi, recipient_city, recipient_state, total_amount_of_payment_usdollars, date_of_payment, nature_of_payment_or_transfer_of_value, applicable_manufacturer_or_applicable_gpo_making_payment_name, name_of_drug_or_biological_or_device_or_medical_supply)
    SELECT
    Covered_Recipient_NPI,
    ISNULL(Recipient_City, 'Not Available'),
    ISNULL(Recipient_State, 'Not Available'),
    Total_Amount_of_Payment_USDollars,
    Date_of_Payment,
    Nature_of_Payment_or_Transfer_of_Value,
    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name,
    Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1
    FROM bronze.cms_general_payments
    WHERE Covered_Recipient_NPI IS NOT NULL
    ORDER BY 1
;


INSERT INTO silver.cms_research_payments(principal_investigator_npi, principal_investigator_city, principal_investigator_state, principal_investigator_primary_type, principal_investigator_specialty, submitting_applicable_manufacturer_or_applicable_gpo_name, applicable_manufacturer_or_applicable_gpo_making_payment_id, applicable_manufacturer_or_applicable_gpo_making_payment_name, indicate_drug_or_biological_or_device_or_medical_supply, name_of_drug_or_biological_or_device_or_medical_supply, total_amount_of_payment_usdollars, date_of_payment, form_of_payment_or_transfer_of_value)
    SELECT
        Principal_Investigator_1_NPI,
        ISNULL(Principal_Investigator_1_City, 'Unknown'),
        ISNULL(Principal_Investigator_1_State, 'Unknown'),
        ISNULL(Principal_Investigator_1_Primary_Type_1, 'Unknown'),
        ISNULL(Principal_Investigator_1_Specialty_1, 'Unknown'),
        Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name,
        Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID,
        Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name,
        ISNULL(Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1, 'Unknown'),
        ISNULL(Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1, 'Unknown'),
        Total_Amount_of_Payment_USDollars,
        Date_of_Payment,
        Form_of_Payment_or_Transfer_of_Value
    FROM bronze.cms_research_payments
    WHERE Principal_Investigator_1_NPI IS NOT NULL
    ORDER BY 1 ASC
;


INSERT INTO silver.cms_ownership_payments (physician_npi, recipient_city, recipient_state, physician_primary_type, physician_specialty, total_amount_invested_usdollars, value_of_interest, terms_of_interest, submitting_applicable_manufacturer_or_applicable_gpo_name, applicable_manufacturer_or_applicable_gpo_making_payment_id, applicable_manufacturer_or_applicable_gpo_making_payment_name, interest_held_by_physician_or_an_immediate_family_member, payment_publication_date, contains_npi)
    SELECT
        Physician_NPI,
        Recipient_City,
        Recipient_State,
        Physician_Primary_Type,
        Physician_Specialty,
        Total_Amount_Invested_USDollars,
        Value_of_Interest,
        Terms_of_Interest,
        Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name,
        Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID,
        Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name,
        Interest_Held_by_Physician_or_an_Immediate_Family_Member,
        Payment_Publication_Date,
        CASE
            WHEN Physician_NPI IS NULL THEN 0
            ELSE 1
        END AS is_attributed
    FROM bronze.cms_ownership_payments


WITH duplicate_hcpcs AS (
    SELECT
            [HCPCS Code],
            [Short Descriptor],
            CASE
                WHEN [Subject to Multiple Procedure Discounting] = 'N' THEN 0
                WHEN [Subject to Multiple Procedure Discounting] = 'Y' THEN 1
                ELSE [Subject to Multiple Procedure Discounting]
            END AS [Subject to Multiple Procedure Discounting],
            [Proposed CY 2026 Payment Indicator],
            [Proposed CY 2026 Payment Weight],
            [Proposed CY 2026 Payment Rate],
            COUNT(*) AS duplicate_count
        FROM bronze.cms_asc_codes
        GROUP BY         [HCPCS Code],
            [Short Descriptor],
            CASE
                WHEN [Subject to Multiple Procedure Discounting] = 'N' THEN 0
                WHEN [Subject to Multiple Procedure Discounting] = 'Y' THEN 1
                ELSE [Subject to Multiple Procedure Discounting]
            END,
            [Proposed CY 2026 Payment Indicator],
            [Proposed CY 2026 Payment Weight],
            [Proposed CY 2026 Payment Rate]
        HAVING COUNT(*) = 1
)
INSERT INTO silver.cms_asc_codes (hcpcs_code, hcpcs_description, is_discountable, payment_indicator, payment_weight, payment_rate)
    SELECT
        [HCPCS Code],
        [Short Descriptor],
        [Subject to Multiple Procedure Discounting],
        [Proposed CY 2026 Payment Indicator],
        [Proposed CY 2026 Payment Weight],
        [Proposed CY 2026 Payment Rate]
    FROM duplicate_hcpcs



INSERT INTO silver.cms_facility_info (facility_enrollment_id, facility_npi, facility_ccn, facility_legal_name, 
facility_business_name, facility_entity_type, facility_ownership_type, facility_address, facility_city, facility_state, 
is_acute_care_facility)
    SELECT
        [ENROLLMENT ID],
        NPI,
        CCN,
        UPPER([ORGANIZATION NAME]),
        COALESCE([DOING BUSINESS AS NAME], 'Unknown'),
        [ORGANIZATION TYPE STRUCTURE],
        CASE 
            WHEN [PROPRIETARY NONPROFIT] = 'P' THEN 'Proprietary'
            WHEN [PROPRIETARY NONPROFIT] = 'N' THEN 'Non-Profit'
            ELSE 'Other'
        END AS [PROPRIETARY NONPROFIT],
        [ADDRESS LINE 1],
        CITY,
        [STATE],
        CASE
            WHEN [SUBGROUP - ACUTE CARE] = 'Y' THEN 1
            ELSE 0
        END AS [SUBGROUP - ACUTE CARE]
    FROM bronze.cms_facility_info