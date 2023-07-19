#!/usr/bin/env python3

"""Format the clades tsv file to be used in the matutils."""

import argparse
import pandas as pd

def parser():
    """Parse command line arguments.

    Returns:
        argparse.Namespace: Object containing the command line arguments.
    """
    parser = argparse.ArgumentParser(description='Extract lineage and strain columns from metadata file')
    parser.add_argument("-m", "--metadata_file", help="Metadata file", required=True)
    parser.add_argument("-s", "--strain_col", help="Strain column name", default='strain')
    parser.add_argument("-l", "--lineage_col", help="Lineage column name", default='lineage')
    parser.add_argument("-o", "--output_file", help="Output file", required=True)
    args = parser.parse_args()
    return args

def switch_columns(df, col1, col2):
    """Switch the columns in the dataframe.
    
    Args:
        df (pandas.DataFrame): Dataframe to switch columns.

    Returns:
        pandas.DataFrame: Dataframe with switched columns.
    """
    # reverse the order of the columns
    df = df.loc[:,[col2, col1]]
    return df.copy()

def main():
    """Main function."""
    args = parser()

    # read in the metadata file
    df = pd.read_csv(args.metadata_file, sep='\t')

    # switch the columns
    df = switch_columns(df[[args.strain_col, args.lineage_col]].copy(), args.strain_col, args.lineage_col)

    # write the dataframe to a tsv file
    df.to_csv(args.output_file, sep='\t', index=False, header=False)

if __name__ == '__main__':
    main()
