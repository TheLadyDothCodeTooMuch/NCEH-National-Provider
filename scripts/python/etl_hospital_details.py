import pandas as pd
import os
from sqlalchemy import create_engine


# deleted, only to add ASSOCIATE ID to the mix
KEEP_COLS = {
        "facility_info": [
            "ENROLLMENT ID",
            "NPI",
            "CCN",
            "ASSOCIATE ID",
            "ORGANIZATION NAME",
            "DOING BUSINESS AS NAME",
            "ORGANIZATION TYPE STRUCTURE",
            "PROPRIETARY NONPROFIT",
            "ADDRESS LINE 1",
            "CITY",
            "STATE",
            "SUBGROUP - ACUTE CARE",
    ]
}

FILE_NAMES = {
    "Hospital_Enrollments_2026.04.01.csv": "cms_facility_info.csv"
}


PATH = r"...\Project\Healthcare\datasets\\"

def main():
    engine = get_engine()

    try:
        for (input_file, output_file), cols in zip(FILE_NAMES.items(), KEEP_COLS.values()):
            read_file = os.path.join(PATH, input_file)

            print(f"Reading from {input_file}")
            
            # A 'UTF-8 codec can't decode' error occurred because of the file name. used encoding='unicode_escape' to bypass this
            df = pd.read_csv(read_file, usecols=cols, encoding='unicode_escape')
            df.to_csv(output_file, index=False, mode='a', header=True)
            print(f"Successfully saved data into {output_file}\n...")

            table_name = f"{output_file.replace(".csv", "")}"
            print(f"Loading data into {table_name}")
    
            # forgot to add schema="bronze". If you already have a schema, don't forget to add this parameter with the schema name. Otherwise, the table will be automatically saved in a schema known as 'dbo' 
            df.to_sql(table_name, engine, schema="bronze", if_exists="append", index=False)

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
