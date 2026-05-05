import pandas as pd
import os
from sqlalchemy import create_engine


KEEP_COLS = {
    "national_downloadable_file": [
        "NPI",
        "Ind_PAC_ID",
        "Ind_enrl_ID",
        "Provider Last Name",
        "Provider First Name",
        "gndr",
        "pri_spec",
        "Facility Name",
        "org_pac_id",
        "num_org_mem",
        "City/Town",
        "State",
        "ind_assgn",
        "grp_assgn",
        "adrs_id",
    ],
    "facility_affiliations": [
        "NPI",
        "Ind_PAC_ID",
        "facility_type",
        "Facility Affiliations Certification Number",
        "Facility Type Certification Number",
    ],
    "providers_and_services": [
        "Rndrng_NPI",
        "HCPCS_Cd",
        "HCPCS_Desc",
        "HCPCS_Drug_Ind",
        "Place_Of_Srvc",
        "Tot_Benes",
        "Tot_Srvcs",
        "Tot_Bene_Day_Srvcs",
        "Avg_Sbmtd_Chrg",
        "Avg_Mdcr_Alowd_Amt",
        "Avg_Mdcr_Pymt_Amt",
        "Avg_Mdcr_Stdzd_Amt",
    ],
    "hospital_general_information": [
        "Facility ID",
        "Facility Name",
        "Address",
        "City/Town",
        "State",
        "Hospital Type",
        "Hospital Ownership",
        "Emergency Services",
        "Hospital overall rating",
        "Hospital overall rating footnote",
    ],
    "taxonomy": ["HCPCS_Cd", "RBCS_Cat_Desc", "RBCS_Subcat_Desc", "RBCS_Family_Desc"],
    "general_payments": [
        "Covered_Recipient_NPI",
        "Recipient_City",
        "Recipient_State",
        "Total_Amount_of_Payment_USDollars",
        "Date_of_Payment",
        "Nature_of_Payment_or_Transfer_of_Value",
        "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name",
        "Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1",
    ],
    "research_payments": [
        "Principal_Investigator_1_NPI",
        "Principal_Investigator_1_City",
        "Principal_Investigator_1_State",
        "Principal_Investigator_1_Primary_Type_1",
        "Principal_Investigator_1_Specialty_1",
        "Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name",
        "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID",
        "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name",
        "Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1",
        "Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1",
        "Total_Amount_of_Payment_USDollars",
        "Date_of_Payment",
        "Form_of_Payment_or_Transfer_of_Value",
    ],
    "ownership_payments": [
        "Physician_NPI",
        "Recipient_City",
        "Recipient_State",
        "Physician_Primary_Type",
        "Physician_Specialty",
        "Total_Amount_Invested_USDollars",
        "Value_of_Interest",
        "Terms_of_Interest",
        "Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name",
        "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID",
        "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name",
        "Interest_Held_by_Physician_or_an_Immediate_Family_Member",
        "Payment_Publication_Date"
    ],
}

FILE_NAMES = {
    "DAC_NationalDownloadableFile.csv": "cms_doctor_info.csv",
    "Facility_Affiliation.csv": "cms_facility_info.csv",
    "MUP_PHY_R25_P05_V20_D23_Prov_Svc.csv": "cms_providers_and_services.csv",
    "Hospital_General_Information.csv": "cms_hospital_rating.csv",
    "RBCS_Taxonomy_RY2025.csv": "cms_rbcs_taxonomy.csv",
    "OP_DTL_GNRL_PGYR2023_P01232026_01102026.csv": "cms_general_payments.csv",
    "OP_DTL_RSRCH_PGYR2023_P01232026_01102026.csv": "cms_research_payments.csv",
    "OP_DTL_OWNRSHP_PGYR2023_P01232026_01102026.csv": "cms_ownership_payments.csv",
}


PATH = r"C:\Users\chika\OneDrive\Desktop\Project\Healthcare\datasets\\"


def main():
    engine = get_engine()

    chunk_size = 200000

    try:
        for (input_file, output_file), cols in zip(FILE_NAMES.items(), KEEP_COLS.values()):
            read_file = os.path.join(PATH, input_file)

            print(f"Reading from {input_file}")

            for i, chunk in enumerate(
                pd.read_csv(read_file, chunksize=chunk_size, low_memory=False, usecols=cols)
            ):
                mode = "w" if i == 0 else "a"
                header = True if i == 0 else False

                chunk.to_csv(output_file, index=False, mode=mode, header=header)

                table_name = f"{output_file.replace(".csv", "")}"
                print(f"Loading data into {table_name}: batch {i+1}")
        
                # forgot to add schema="bronze". If you already have a schema, don't forget to add this parameter with the schema name. Otherwise, the table will be automatically saved in a schema known as 'dbo' 
                chunk.to_sql(table_name, engine, schema="bronze", if_exists="append", index=False)

            print(f"Successfully saved data into {output_file}\n...")
            print(f"Successfully loaded data into {table_name}\n...")
    except FileNotFoundError as fnfe:
        print(f"Check file name or path again: {fnfe}")
    except Exception as e:
        print(f"An error occured while loading the table: {e}")

       
def get_engine() -> Engine:
    connection_url = (
        "mssql+pyodbc://Chika\\SQLEXPRESS/NCEH_Clinical_Operations_2026?"
        "driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes"
    )
    return create_engine(connection_url, fast_executemany=True)


if __name__ == "__main__":
    main()
