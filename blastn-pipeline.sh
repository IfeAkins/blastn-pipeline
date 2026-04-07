#!/bin/bash
# ============================================
# BLASTn Pipeline
# ============================================
# CONFIGURATION
# Edit these variables before running
# ============================================
REFERENCE_DIR="reference"                    # reference folder
REFERENCE_FASTA="reference/*.fasta"          # reference file
DATABASE_NAME="reference/blast_db"           # database location, rename if necessary
FASTA_DIR="fasta"                            # query fasta folder
RESULTS_DIR="results"                        # results folder

# ============================================
# STEP 1: Create BLAST database
# ============================================
echo "Step 1: Creating BLAST database..."

makeblastdb \
    -in ${REFERENCE_FASTA} \
    -dbtype nucl \
    -out ${DATABASE_NAME}

echo "Database created successfully!"

# ============================================
# STEP 2: List all query FASTA files
# ============================================
echo "Step 2: Listing query FASTA files..."

ls ${FASTA_DIR}/*.fasta > samples.txt

echo "Found $(wc -l < samples.txt) samples to process"

# ============================================
# STEP 3: Run BLASTn for each sample
# ============================================
echo "Step 3: Running BLASTn for each sample..."

for fasta in $(cat samples.txt); do
    echo "  Processing: ${fasta}"
    blastn \
        -query ${fasta} \
        -db ${DATABASE_NAME} \
        -out ${fasta}.txt \
        -outfmt "6 qseqid sseqid score qcovs pident qlen slen length" \
        -perc_identity 90
done

echo "BLASTn complete!"

# ============================================
# STEP 4: Organize results
# ============================================
echo "Step 4: Organizing results..."

mkdir -p ${RESULTS_DIR}/
mv ${FASTA_DIR}/*.fasta.txt ${RESULTS_DIR}/

echo "Results moved to ${RESULTS_DIR}/ folder"

# ============================================
# STEP 5: Create summary header
# ============================================
echo "Step 5: Creating summary file..."

echo -e "sample_id\tquery_seq_id\tsubject_seq_id\tscore\tquery_cov\tseq_ident\tquery_len\tsubject_len\taln_len" \
    > blast_results_summary.tsv

# ============================================
# STEP 6: Combine all results into summary
# ============================================
echo "Step 6: Combining results..."

for file in $(ls ${RESULTS_DIR}/*.txt); do
    sample=$(basename ${file%.fasta.txt})
    
    while IFS= read -r line; do
        echo -e "${sample}\t${line}" >> blast_results_summary.tsv
    done < ${file}
done

echo "============================================"
echo "Pipeline complete!"
echo "Results saved in: blast_results_summary.tsv"
echo "============================================"
