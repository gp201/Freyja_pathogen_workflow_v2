import pandas as pd
from Bio import SeqIO
import argparse
from collections import OrderedDict
from tqdm import tqdm


def read_sample_muts(path):
    df = pd.read_csv(
        path,
        sep="\t",
        names=["sample", "mutations"]
    )

    return df


def parse_args():
    parser = argparse.ArgumentParser(
        description="Get mutations from a sample path"
    )

    parser.add_argument(
        "-s",
        "--sample_muts",
        type=str,
        required=True,
        help="Path to sample mutations file"
    )

    parser.add_argument(
        "-r",
        "--reference",
        type=str,
        required=True,
        help="Path to reference sequence"
    )

    parser.add_argument(
        "-f",
        "--fasta",
        type=str,
        required=True,
        help="Path to FASTA file containing all the sequences"
    )

    parser.add_argument(
        "-l",
        "--lineage_paths",
        type=str,
        required=True,
        help="Path to lineage paths file"
    )

    parser.add_argument(
        "-o",
        "--output",
        type=str,
        required=True,
        help="Path to output file"
    )

    return parser.parse_args()


def pick_sample(sample_muts_df):
    # pick a random sample where the mutations are not null
    sample = sample_muts_df[sample_muts_df["mutations"].notnull()].sample(1)
    return sample


def get_muts(sample):
    muts = {}
    # print(sample)
    tmp = sample["mutations"].split(" ")
    for i in tmp:
        # if i is empty, skip
        if i == "":
            continue
        muts[i.split(":")[0]] = i.split(":")[1].split(",")
    # reverse the dict order
    muts = OrderedDict(reversed(list(muts.items())))
    # print(muts)
    return muts


def reverse_muts_to_root(muts):
    """Reverse the mutations to the root node."""
    root_muts = {}
    for value in muts.values():
        for i in value:
            nuc_loc = int(i[1:-1])
            # Here the tip mutations are reversed to the root node.
            # The base is the nucleotide of the tip node.
            if nuc_loc in root_muts.keys():
                root_muts[nuc_loc]["mut"] = i[0]
            else:
                root_muts[nuc_loc] = {
                    "base": i[-1],
                    "mut": i[0],
                }
    return root_muts


def generate_root_seq(root_muts, seq):
    """Generate the root sequence."""
    for key, value in root_muts.items():
        seq.seq = seq.seq[:int(key)-1] + value["mut"] + seq.seq[int(key):]
    # SeqIO.write(seq, "root.fasta", "fasta")
    return seq


def compare_seqs(ref, root):
    """Compare the root sequence to the mutated sequence."""
    additonal_muts = {}
    for i, nuc in enumerate(zip(ref.seq, root,)):
        ref_nuc = nuc[0]
        root_nuc = nuc[1]
        if ref_nuc.lower() != root_nuc.lower():
            additonal_muts[i+1] = {
                "ref": ref_nuc.lower(),
                "root": root_nuc.lower()
            }
    return additonal_muts


# generate a consensus root sequence
def generate_consensus_root(root_seqs):
    """Generate a consensus root sequence."""
    # for each position in the sequence get the most common nucleotide and add it to the consensus sequence
    consensus_root = ""
    for i in tqdm(range(len(root_seqs[0].seq)), desc="Generating consensus root"):
        nucs = []
        for seq in root_seqs:
            nucs.append(seq.seq[i])
        # elmimate nucleotides that are not A, T, C, or G or if all nucleotides are the same
        nucs = [x for x in nucs if x.upper() in ["A", "T", "C", "G"]
                or len(set(nucs)) == 1]
        consensus_root += max(set(nucs), key=nucs.count)
    return consensus_root


def parse_tree_paths(df):
    df = df.set_index('clade')
    df['from_tree_root'] = df['from_tree_root'].apply(lambda x: x.split(' '))
    return df


def main():
    args = parse_args()
    sample_muts_df = read_sample_muts(args.sample_muts)
    seqs = SeqIO.parse(args.fasta, "fasta")
    ref = SeqIO.read(args.reference, "fasta")
    # if reference in the sample mutations file, use that as the root
    if sample_muts_df[sample_muts_df["sample"] == ref.id].shape[0] > 0:
        additonal_muts = reverse_muts_to_root(get_muts(sample_muts_df[sample_muts_df["sample"] == ref.id].iloc[0]))
        # change base key to ref and mut key to root
        for i in additonal_muts.keys():
            additonal_muts[i]["ref"] = additonal_muts[i].pop("base")
            additonal_muts[i]["root"] = additonal_muts[i].pop("mut")
    # else generate the root sequence
    else:
        root_seqs = []
        for _, sample in tqdm(sample_muts_df[sample_muts_df["mutations"].notnull()].iterrows(), total=sample_muts_df[sample_muts_df["mutations"].notnull()].shape[0], desc="Generating root sequences"):
            root_muts = reverse_muts_to_root(get_muts(sample))
            for i in seqs:
                if sample["sample"] in i.id:
                    seq = i
                    break
            root_seqs.append(generate_root_seq(root_muts, seq))
        root = generate_consensus_root(root_seqs)
        additonal_muts = compare_seqs(ref, root)

    # convert to dataframe and save as csv
    df = pd.DataFrame.from_dict(additonal_muts, orient="index")
    df.to_csv(args.output, sep="\t", index_label="position")
    lineage_paths = parse_tree_paths(pd.read_csv(args.lineage_paths, sep='\t'))
    print(lineage_paths.head(1)["from_tree_root"].values[0])
    # append additional mutations to the begining from_tree_root column list
    additional_muts_list = []
    for i in additonal_muts.keys():
        # Note: Insertions and deletions are not included in the additional mutations list
        if '-' in additonal_muts[i]['root'] or '-' in additonal_muts[i]['ref']:
            continue
        additional_muts_list.append(str(additonal_muts[i]['ref'] + str(i) + additonal_muts[i]['root']))
    if additional_muts_list == []:
        print("No additional mutations found.")
        # duplicate lineage paths file
        lineage_paths['from_tree_root'] = lineage_paths['from_tree_root'].apply(lambda x: ' '.join(x))
    else:
        print("Mutations found.")
        # add the additional mutations to the lineage paths after the first item
        lineage_paths['from_tree_root'] = lineage_paths['from_tree_root'].apply(lambda x: x[0] + ' ' + ','.join(additional_muts_list) + ' ' + ' '.join(x[1:]))
        # lineage_paths['from_tree_root'] = lineage_paths['from_tree_root'].apply(lambda x: ' '.join(x))
    lineage_paths.to_csv(args.lineage_paths + '.rerooted', sep='\t')


if __name__ == "__main__":
    main()
