#!/usr/bin/env python3

import altair as alt
import pandas as pd

barcode = pd.read_csv("barcode.csv", header=0, index_col=0)

# convert barcode dataframe to long format
barcode = barcode.stack().reset_index()
barcode.columns = ["Lineage", "Mutation", "z"]

# plot without mutation labels
alt.Chart(barcode).mark_rect(stroke='#dadfd8', strokeWidth=0.25).encode(
    y='Lineage',
    x=alt.X('Mutation', axis=alt.Axis(labels=False, tickSize=0)),
    color=alt.Color('z', scale=alt.Scale(range=['#f8fbf5','#0e4d28'])),
    tooltip=['Lineage', 'Mutation', 'z']
).properties(
    width=500,
    height=250
).save("barcode.html")
