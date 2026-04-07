# BLASTn Pipeline
A bash pipeline for running BLASTn 
sequence similarity searches against a custom 
nucleotide database, with automated result 
summarization.

## What it does
- Creates a custom BLAST nucleotide database
- Runs BLASTn for multiple query sequences automatically
- Reports all hits per sample
- Samples with no hits are recorded as zeros

## Requirements
- [BLAST+](https://blast.ncbi.nlm.nih.gov/doc/blast-help/downloadblastdata.html)
- Python 3 and pandas — optional, for filtering only (`pip install pandas`)

## Directory Structure
```
blastn-pipeline/
├── blastn_pipeline.sh        ← main pipeline script
├── filter_blast_results.py   ← optional filter script
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

## Output Files

### blast_results_summary.tsv
Raw combined results from all samples.

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

## Filtering Results (Optional)

Results can be filtered in two ways:

### Option 1 — Python script
```bash
python filter_blast_results.py
```
Filters by reference coverage > 80% and sequence identity > 90%.
Adjust thresholds inside the script:
```python
COVERAGE_THRESHOLD = 80
IDENTITY_THRESHOLD = 90
```
Output: `blast_results_filtered.tsv`

### Option 2 — Excel
Open `blast_results_summary.tsv` directly in Excel:
- Calculate reference coverage: `= (aln_len / subject_len) * 100`
- Filter by coverage > 80% and seq_ident > 90%
- No Python required

## Note on query_cov
The `query_cov` column reports the percentage 
of the query contig covered by the alignment. 
For large query sequences (e.g. whole chromosomes), 
this value will be low even when the full reference 
gene is present. Use `ref_coverage_%` in the 
filtered output for accurate coverage assessment.

## Applications
This pipeline can be used for any nucleotide 
sequence search (AMR genes, virulence genes, 
plasmid replicons etc)

## Example
Example input and output files are provided 
in the `example/` folder.

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
```
