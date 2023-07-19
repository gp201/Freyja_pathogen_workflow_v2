#!/usr/bin/env python3

import altair as alt
import pandas as pd
import argparse

def plot(barcode):
    alt.Chart(barcode).mark_rect(stroke='#dadfd8', strokeWidth=0.25).encode(
        y='Lineage',
        x=alt.X('Mutation', axis=alt.Axis(labels=False, tickSize=0)),
        color=alt.Color('z', scale=alt.Scale(range=['#f8fbf5','#0e4d28'])),
        tooltip=['Lineage', 'Mutation', 'z']
    ).properties(
        width=500,
        height=250
    ).save("barcode.html")

def parser():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(
        description="Plot barcode from CSV file."
    )
    parser.add_argument(
        "-i",
        "--input",
        type=str,
        required=True,
        help="Input CSV file"
    )
    return parser.parse_args()

def main():
    args = parser()
    barcode = pd.read_csv(args.input, header=0, index_col=0)

    # convert barcode dataframe to long format
    barcode = barcode.stack().reset_index()
    barcode.columns = ["Lineage", "Mutation", "z"]
    plot(barcode)

if __name__ == '__main__':
    main()