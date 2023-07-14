"""Common utility functions used by the scripts in this directory."""

import pandas as pd
import configparser


def read_csv_tsv(file_path):
    """Reads a csv or tsv file and returns a pandas dataframe.

    Args:
        file_path (str): Path to the csv or tsv file.

    Returns:
        pandas.DataFrame: Dataframe containing the data from the csv or tsv file.

    Raises:
        ValueError: If the file type is not csv or tsv.
    """
    if file_path.endswith('.csv'):
        return pd.read_csv(file_path)
    elif file_path.endswith('.tsv'):
        return pd.read_csv(file_path, sep='\t')
    else:
        raise ValueError(
            'File type not supported. Please use csv or tsv files.')
