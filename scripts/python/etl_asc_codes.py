import pandas as pd
import os
from sqlalchemy import create_engine


KEEP_COLS = {
        "asc_codes": [
            "HCPCS Code",
            "Short Descriptor",
            "Subject to Multiple Procedure Discounting",
            "Proposed CY 2026 Payment Indicator",
            "Proposed CY 2026 Payment Weight",
            "Proposed CY 2026 Payment Rate",
    ]
}

FILE_NAMES = {
    "2026 NPRM ASC Addenda.xlsx": "cms_asc_codes.csv"
}


PATH = r"\Project\Healthcare\datasets\\"

def main():
    engine = get_engine()

    try:
        for (input_file, output_file), cols in zip(FILE_NAMES.items(), KEEP_COLS.values()):
            read_file = os.path.join(PATH, input_file)

            print(f"Reading from {input_file}")
            
            df = pd.read_excel(read_file, sheet_name="CY 2026 ASC AA", skiprows=3, usecols=cols, skipfooter=8)
            df.to_csv(output_file, index=False, mode='a', header=True)

            table_name = f"{output_file.replace(".csv", "")}"
            print(f"Loading data into {table_name}")
    
            # forgot to add schema="bronze". If you already have a schema, don't forget to add this parameter with the schema name. Otherwise, the table will be automatically saved in a schema known as 'dbo' 
            df.to_sql(table_name, engine, schema="bronze", if_exists="append", index=False)

            print(f"Successfully saved data into {output_file}\n...")
            print(f"Successfully loaded data into {table_name}\n...")
    except FileNotFoundError as fnfe:
        print(f"Check file name or path again: {fnfe}")
    except Exception as e:
        print(f"An error occured while loading the table: {e}")

       
def get_engine() -> Engine:
    connection_url = (
        "mssql+pyodbc://...\\SQLEXPRESS/NCEH_Clinical_Operations_2026?"
        "driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes"
    )
    return create_engine(connection_url, fast_executemany=True)


if __name__ == "__main__":
    main()
