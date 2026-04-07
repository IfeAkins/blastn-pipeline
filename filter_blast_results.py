import pandas as pd

df = pd.read_csv("blast_results_summary.tsv", sep="\t")

# calculate reference coverage
ref_length = df[df['aln_len'] != 0]['subject_len'].max()
df['ref_coverage_%'] = round((df['aln_len'] / ref_length) * 100, 2)

# filter
df_filtered = df[
    (df['ref_coverage_%'] > 80) &
    (df['seq_ident'] > 90)
]

print(df_filtered)
df_filtered.to_csv("blast_results_filtered.tsv", sep='\t', index=False)
