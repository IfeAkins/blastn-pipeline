#!/bin/bash

# BLASTn Pipeline
# Author: Ifeoluwa Akintayo

REFERENCE_DIR="reference"
REFERENCE_FASTA="reference/*.fasta"
DATABASE_NAME="reference/blast_db"
FASTA_DIR="fasta"
RESULTS_DIR="results"
SUMMARY_FILE="blast_results_summary.tsv"
IDENTITY_THRESHOLD=90

echo "BLASTn Pipeline"
echo "Author: Dr. Ifeoluwa Akintayo"

# STEP 1: Create BLAST database
echo ""
echo "Step 1: Creating BLAST database..."

makeblastdb \
    -in ${REFERENCE_FASTA} \
    -dbtype nucl \
    -out ${DATABASE_NAME}

echo "Database created: ${DATABASE_NAME}"


# STEP 2: Create results directory

mkdir -p ${RESULTS_DIR}
echo ""
echo "Step 2: Results folder ready: ${RESULTS_DIR}/"

# STEP 3: Run BLASTn for each sample

echo "Step 3: Running BLASTn for each sample..."
echo "Identity threshold: ${IDENTITY_THRESHOLD}%"


for fasta in ${FASTA_DIR}/*.fasta; do
    sample=$(basename ${fasta%.fasta})
    echo "  Processing: ${sample}"

    blastn \
        -query ${fasta} \
        -db ${DATABASE_NAME} \
        -out ${RESULTS_DIR}/${sample}.txt \
        -outfmt "6 qseqid sseqid score qcovs pident qlen slen length" \
        -perc_identity ${IDENTITY_THRESHOLD}
done

echo ""
echo "BLASTn complete!"

# STEP 4: Create summary header

echo ""
echo "Step 4: Creating summary file..."

echo -e "sample_id\tquery_seq_id\tsubject_seq_id\tscore\tquery_cov\tseq_ident\tquery_len\tsubject_len\taln_len" \
    > ${SUMMARY_FILE}

# STEP 5: Combine all results into summary

echo "Step 5: Combining results..."

# get reference name and length for no-hit rows
REF_NAME=$(grep ">" ${REFERENCE_FASTA} | head -1 | sed 's/>//' | awk '{print $1}')
REF_LEN=$(awk '/^>/{if(seq) print length(seq); seq=""} !/^>/{seq=seq$0} END{print length(seq)}' ${REFERENCE_FASTA})

for file in $(ls ${RESULTS_DIR}/*.txt); do
    sample=$(basename ${file%.txt})

    if [ -s ${file} ]; then
        while IFS= read -r line; do
            echo -e "${sample}\t${line}" >> ${SUMMARY_FILE}
        done < ${file}
    else
        echo -e "${sample}\t0\t${REF_NAME}\t0\t0\t0\t0\t${REF_LEN}\t0" >> ${SUMMARY_FILE}
    fi
done


echo "Pipeline complete!"
echo "Results folder:  ${RESULTS_DIR}/"
echo "Summary file:    ${SUMMARY_FILE}"

