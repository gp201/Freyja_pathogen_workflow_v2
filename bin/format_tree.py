#!/usr/bin/env python3

"""Converts a nexus file to a newick file."""

import argparse
import dendropy
from ete3 import Tree


def parser():
    """Parses the command line arguments.

    Returns:
        argparse.Namespace: Object containing the command line arguments.
    """
    parser = argparse.ArgumentParser(
        description='Convert a nexus file to newick format')
    parser.add_argument("-i", "--input", help="Nexus file", required=True)
    parser.add_argument("-f", "--format", help="Format of the nexus file",
                        choices=["nexus", "newick"], default="nexus")
    parser.add_argument("-r", "--reformat",
                        help="Reformat using ete3", action="store_true")
    parser.add_argument("-o", "--output", help="Newick file", required=True)
    args = parser.parse_args()
    return args


def convert():
    """Converts a nexus file to a newick file."""
    args = parser()

    tree = dendropy.Tree.get_from_path(args.input, args.format, suppress_leaf_node_taxa=False,
                                       suppress_internal_node_taxa=True, case_sensitive_taxon_labels=True, preserve_underscores=True)
    tree.write_to_path(args.output, "newick")

    if args.reformat:
        with open(args.output, "r") as f:
            tree = f.read()
        t = Tree(tree, format=1)
        t.write(format=0, outfile=args.output)


if __name__ == '__main__':
    convert()
