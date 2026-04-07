# BLASTn Pipeline

A bash script for running BLASTn sequence similarity 
searches against a custom nucleotide database, 
with automated result summarization.

## What it does
- Creates a custom BLAST nucleotide database
- Runs BLASTn for multiple query sequences automatically
- Organizes results into a single summary TSV file
- Reports key alignment statistics per hit

## Requirements
- [BLAST+](https://blast.ncbi.nlm.nih.gov/doc/blast-help/downloadblastdata.html) 
  installed and in PATH

Check installation:
```bash
blastn -version
```

## Input
- Reference gene sequence in FASTA format 
  (for database creation)
- Query sequences as individual FASTA files 
  in working directory

## Usage

### Step 1 — Make script executable
```bash
chmod +x blastn_pipeline.sh
```

### Step 2 — Edit script
Open `blastn_pipeline.sh` and replace:
```
<reference_gene.fasta> → your reference file
<database_name>        → your chosen database name
```

### Step 3 — Run
```bash
bash blastn_pipeline.sh
```

## Output
### Individual results
Saved in `results/` folder — one file per sample

### Summary file
`blast_results_summary.tsv` — all results combined

| Column | Description |
|---|---|
| id | Sample/isolate name |
| query_seq_id | Query sequence identifier |
| subject_seq_id | Database sequence identifier |
| score | Alignment score (higher = better) |
| query_cov | Query coverage (%) |
| seq_ident | Sequence identity (%) |

## Recommended Filters
```
query_cov  > 80%  → good coverage
seq_ident  > 90%  → high identity
score      > 200  → strong alignment
```

## Further Analysis
Results can be filtered and analyzed using Python pandas:
```python
import pandas as pd

df = pd.read_csv("blast_results_summary.tsv", sep=" ")
df_filtered = df[
    (df['query_cov'] > 80) &
    (df['seq_ident'] > 90)
]
print(df_filtered)
```


## License
MIT License
