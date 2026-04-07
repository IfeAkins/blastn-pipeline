# BLASTn Pipeline

A bash and Python pipeline for running BLASTn 
sequence similarity searches against a custom 
nucleotide database, with automated result 
filtering and summarization.

## What it does
- Creates a custom BLAST nucleotide database
- Runs BLASTn for multiple query sequences automatically
- Reports all hits per sample
- Samples with no hits are recorded as zeros
- Filters results by reference coverage and sequence identity

## Requirements
- [BLAST+](https://blast.ncbi.nlm.nih.gov/doc/blast-help/downloadblastdata.html)
- Python 3
- pandas (`pip install pandas`)

## Directory Structure
```
blastn-pipeline/
├── blastn_pipeline.sh        ← main pipeline script
├── filter_blast_results.py   ← filter and summarize results
├── README.md
├── reference/
│   └── your_reference.fasta  ← put reference sequence here
└── fasta/
    └── *.fasta               ← put query sequences here
```

## Usage

### Step 1 — Set up directories
```bash
mkdir reference fasta
cp your_reference.fasta reference/
cp your_query_sequences/*.fasta fasta/
```

### Step 2 — Edit configuration
Open `blastn_pipeline.sh` and edit:
```bash
IDENTITY_THRESHOLD=90   # adjust as needed
```

### Step 3 — Run pipeline
download the script
```bash
chmod +x blastn_pipeline.sh
bash blastn_pipeline.sh
```

### Step 4 — Filter results
```bash
python filter_blast_results.py
```

## Output Files

### blast_results_summary.tsv
Raw combined results from all samples in cwd.

| Column | Description |
|---|---|
| sample_id | Sample/isolate name |
| query_seq_id | Query contig identifier |
| subject_seq_id | Database sequence identifier |
| score | Alignment score |
| query_cov | Query coverage (%) |
| seq_ident | Sequence identity (%) |
| query_len | Query sequence length (bp) |
| subject_len | Reference sequence length (bp) |
| aln_len | Alignment length (bp) |

### blast_results_filtered.tsv
Hits passing quality filters:
- Reference coverage > 80%
- Sequence identity > 90%

## Note on query_cov
The `query_cov` column reports the percentage 
of the query contig covered by the alignment. 
For large query sequences (e.g. whole chromosomes), 
this value will be low even when the full reference 
gene is present. Use `ref_coverage_%` in the 
filtered output for accurate coverage assessment.

## Applications
This pipeline can be used for any nucleotide sequence search(AMR gene, virulence gene etc)

## References
- Camacho C et al. (2009) BLAST+: architecture 
  and applications. *BMC Bioinformatics* 10:421
  https://doi.org/10.1186/1471-2105-10-421

- NCBI BLAST+ Command Line Manual:
  https://www.ncbi.nlm.nih.gov/books/NBK153387/

## Author
Ifeoluwa Akintayo, PhD

## License
MIT License
