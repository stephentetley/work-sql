
from argparse import ArgumentParser
import glob
from pathlib import Path
import duckdb

def make_parquet(path: str, read_sheet_args: str, con: duckdb.DuckDBPyConnection):
    outpath = Path(path).with_suffix(".parquet")
    
    con.execute("INSTALL rusty_sheet FROM community;")
    con.execute("LOAD rusty_sheet;")

    read_sql = f"""
        CREATE OR REPLACE TABLE landing AS
        SELECT
            *
        FROM read_sheet(
            '{path}'
            {read_sheet_args});
    """
    con.execute(read_sql)
    write_sql = f"""
        COPY 
            (SELECT * FROM landing) 
        TO '{outpath}' 
        (FORMAT parquet, COMPRESSION uncompressed);
    """
    con.execute(write_sql)
    print(f"Wrote {outpath}")
    


def main(): 
    parser = ArgumentParser(description='Generate a Parquet file for each xls file in a glob')
    parser.add_argument("--glob", dest='glob', required=True, help="path glob")
    parser.add_argument("--read_sheet_args", dest='read_sheet_args', required=True, help="args to supply to read_sheet()")
    args = parser.parse_args()
    glob_to_xls = args.glob
    read_sheet_args = args.read_sheet_args

    con = duckdb.connect()

    for file in list(glob.glob(glob_to_xls)): 
        make_parquet(file, read_sheet_args, con)

    con.close()
main()
