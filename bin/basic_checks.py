#!/usr/bin/env python3

"""Performs basic checks on the fasta file and metadata file."""

from common import *

import sys
import argparse


def get_fasta_headers(fasta_file):
    """Gets the fasta headers from a fasta file.

    Args:
        fasta_file (str): Path to the fasta file.

    Returns:
        list: List of fasta headers.
    """
    fasta_headers = []
    with open(fasta_file) as f:
        for line in f:
            if line.startswith('>'):
                fasta_headers.append(line.strip()[1:])
    return fasta_headers


def check_duplicate_fasta_headers(fasta_file):
    """Checks if there are duplicate fasta headers.

    Args:
        fasta_file (str): Path to the fasta file.

    Returns:
        bool: True if there are duplicate fasta headers, False otherwise.
    """
    fasta_headers = get_fasta_headers(fasta_file)
    if len(fasta_headers) != len(set(fasta_headers)):
        # print the duplicate fasta headers
        print('Duplicate fasta headers:')
        for header in fasta_headers:
            if fasta_headers.count(header) > 1:
                print(header)
        return True
    else:
        return False


def check_duplicate_metadata(metadata_file, column):
    """Checks if there are duplicate values in a column of the metadata file.

    Args:
        metadata_file (str): Path to the metadata file.
        column (str): Column name of the metadata file.

    Returns:
        bool: True if there are duplicate values in the column, False otherwise.
    """
    metadata = read_csv_tsv(metadata_file)
    if len(metadata[column]) != len(set(metadata[column])):
        # print the duplicate values
        print('Duplicate values in column {}:'.format(column))
        for value in metadata[column]:
            if list(metadata[column]).count(value) > 1:
                print(value)
        return True
    else:
        return False


def check_metadata(fasta_file, metadata_file, column):
    """Checks if all fasta headers are present in the metadata file.

    Args:
        fasta_file (str): Path to the fasta file.
        metadata_file (str): Path to the metadata file.
        column (str): Column name of the fasta headers.

    Returns:
        bool: True if all fasta headers are present in the metadata file, False otherwise.
    """
    fasta_headers = get_fasta_headers(fasta_file)
    metadata = read_csv_tsv(metadata_file)
    metadata_headers = list(metadata[column])
    if set(fasta_headers).issubset(set(metadata_headers)):
        return True
    else:
        return False


def parser():
    """Parses the command line arguments.

    Returns:
        argparse.Namespace: Object containing the command line arguments.
    """
    parser = argparse.ArgumentParser(
        description='Performs basic checks on the fasta file and metadata file.')
    parser.add_argument('-f', '--fasta_file', help='Path to the fasta file.')
    parser.add_argument('-c', '--column', type=str, default='strain',
                        help='Column name of the fasta headers. Default: strain')
    parser.add_argument('-m', '--metadata_file',
                        help='Path to the metadata file.')
    return parser.parse_args()


def main():
    """Main function."""
    args = parser()
    fasta_file = args.fasta_file
    metadata_file = args.metadata_file
    column = args.column

    # optimize the above code
    errors = []
    if check_duplicate_fasta_headers(fasta_file):
        errors.append('Duplicate fasta headers')
    if check_duplicate_metadata(metadata_file, column):
        errors.append('Duplicate values in column {}'.format(column))
    if not check_metadata(fasta_file, metadata_file, column):
        errors.append('Fasta headers not found in metadata file')
    if errors:
        # print The following errors were found: in red
        print('\033[91mThe following errors were found:\033[0m')
        for error in errors:
            print('\033[91m- {}\033[0m'.format(error))
        sys.exit(1)
    else:
        print('No errors were found')
        sys.exit(0)


if __name__ == '__main__':
    main()
