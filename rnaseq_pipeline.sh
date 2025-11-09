#!/bin/bash

################################################################################
# RNA-seq Pipeline - Paired-End Version
# Author: Sagar Tank
# Based on standard RNA-seq workflow
################################################################################

SECONDS=0
set -e

# Assign working directory
WORK_DIR="/Users/sagartankbass/Documents/rnaseq-pipeline"
cd ${WORK_DIR}

# Directories
FASTQ_DIR="data/fastq"
REF_DIR="data/reference"
OUT_DIR="results"

# Reference files
GENOME_INDEX="${REF_DIR}/grch38/genome"
GTF="${REF_DIR}/Homo_sapiens.GRCh38.106.gtf"

# Trimmomatic adapters
ADAPTERS="/Users/sagartankbass/miniforge3/share/trimmomatic-0.40-0/adapters/TruSeq3-SE.fa"

# CPU threads
THREADS=4

# Create output directories
mkdir -p ${OUT_DIR}
mkdir -p HISAT2
mkdir -p quants

# STEP 1: Run fastqc

echo "Running FastQC..."
fastqc ${FASTQ_DIR}/demo.fastq -o data/
echo "FastQC complete"

# STEP 2: Trimmomatic

echo "Running Trimmomatic..."
trimmomatic SE -threads ${THREADS} -phred33 \
    ${FASTQ_DIR}/demo.fastq \
    data/demo_trimmed.fastq \
    ILLUMINACLIP:${ADAPTERS}:2:30:10 \
    LEADING:3 TRAILING:10 SLIDINGWINDOW:4:15 MINLEN:36
echo "Trimmomatic complete"

# STEP 3: FastQC on trimmed reads

echo "Running FastQC on trimmed reads..."
fastqc data/demo_trimmed.fastq -o data/
echo " FastQC trimmed complete"

# STEP 4: HISAT2
echo "Running HISAT2 alignment..."
hisat2 -q \
    --rna-strandness R \
    -x ${GENOME_INDEX} \
    -U data/demo_trimmed.fastq \
    | samtools sort -o HISAT2/demo_trimmed.bam
echo "HISAT2 alignment complete"

# STEP 5: featureCounts

echo "Running featureCounts..."
featureCounts -S 2 \
    -a ${GTF} \
    -o quants/demo_featurecounts.txt \
    HISAT2/demo_trimmed.bam
echo "featureCounts complete"

duration=$SECONDS
echo "Runtime: $(($duration / 60)) minutes and $(($duration % 60)) seconds"
