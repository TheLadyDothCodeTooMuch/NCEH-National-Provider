USE NCEH_Clinical_Operations_2026

CREATE NONCLUSTERED INDEX ncix_asc_hcpcs_code
ON silver.cms_asc_codes(hcpcs_code)


CREATE NONCLUSTERED INDEX ncix_cms_pos ON silver.cms_providers_and_services(place_of_service) INCLUDE (hcpcs_code)


CREATE NONCLUSTERED INDEX ncix_pos_hcpc ON silver.cms_providers_and_services(place_of_service, hcpcs_code)


CREATE NONCLUSTERED INDEX IX_POS_HCPCS_Covering 
ON silver.cms_providers_and_services (place_of_service, hcpcs_code) 
INCLUDE (total_service_count);


-- had to drop this index to create PK for the hcpcs codes to make joins faster
DROP INDEX [ncix_asc_hcpcs_code] ON silver.cms_asc_codes


-- dropped this primary key so as to replace with hcpcs codes as a primary key 
ALTER TABLE silver.cms_asc_codes
DROP CONSTRAINT PK__cms_asc___7C36D05EA3A2F4E3


-- altered the table to change the hcpcs_codes column to NOT NULL
-- eventually ended up dropping the silver.cms_asc_codes table all together to create a new one with the hcpcs_codes column 
-- as the PK from the scratch
-- ALTER TABLE silver.cms_asc_codes
-- ALTER COLUMN hcpcs_code NVARCHAR(10) NOT NULL


-- ALTER TABLE silver.cms_asc_codes
-- ADD CONSTRAINT pk_hcpcs_code PRIMARY KEY (hcpcs_code)


