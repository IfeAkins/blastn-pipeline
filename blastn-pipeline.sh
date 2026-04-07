#!/bin/bash
# ============================================
# BLASTn Pipeline
# 
# 
# Description: Automated BLASTn similarity 
# search against a custom nucleotide database
# with result summarization
#
# Reference: Camacho et al. (2009) BLAST+
# BMC Bioinformatics 10:421
# https://doi.org/10.1186/1471-2105-10-421
# ============================================

# ============================================
# STEP 1: Create BLAST database
# ============================================
# Replace <reference_gene.fasta> with your file
# Replace <database_name> with your chosen name

echo "Step 1: Creating BLAST database..."

makeblastdb \
    -in <reference_gene.fasta> \
    -dbtype nucl \
    -out <database_name>

echo "Database created successfully!"

# ============================================
# STEP 2: List all query FASTA files
# ============================================
echo "Step 2: Listing query FASTA files..."

ls *.fasta > samples.txt

echo "Found $(wc -l < samples.txt) samples to process"

# ============================================
# STEP 3: Run BLASTn for each sample
# ============================================
# -query        : query sequence file
# -db           : database from step 1
# -out          : output file per sample
# -outfmt 6     : tabular TSV format
# -perc_identity: minimum % identity threshold

echo "Step 3: Running BLASTn for each sample..."

for fasta in $(cat samples.txt); do
    echo "  Processing: ${fasta}"
    blastn \
        -query ${fasta} \
        -db <database_name> \
        -out ${fasta}.txt \
        -outfmt "6 qseqid sseqid score qcovs pident" \
        -perc_identity 90
done

echo "BLASTn complete!"

# ============================================
# STEP 4: Organize results
# ============================================
echo "Step 4: Organizing results..."

mkdir -p results/
mv *.fasta.txt results/

echo "Results moved to results/ folder"

# ============================================
# STEP 5: Create summary header
# ============================================
# Column descriptions:
# id             = sample name
# query_seq_id   = query sequence ID
# subject_seq_id = database sequence ID
# score          = alignment score
# query_cov      = query coverage (%)
# seq_ident      = sequence identity (%)

echo "Step 5: Creating summary file..."

echo "id query_seq_id subject_seq_id score query_cov seq_ident" \
    > blast_results_summary.tsv

# ============================================
# STEP 6: Combine all results into summary
# ============================================
echo "Step 6: Combining results..."

for file in $(ls results/*.txt); do
    # extract sample name (remove .fasta.txt)
    sample=$(basename ${file%.fasta.txt})
    
    # append sample name + results to summary
    echo "$(echo $sample) $(cat $file)" \
        >> blast_results_summary.tsv
done

echo "============================================"
echo "Pipeline complete!"
echo "Results saved in: blast_results_summary.tsv"
echo "============================================"
