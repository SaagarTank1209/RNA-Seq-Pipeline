# RNA-seq Analysis Pipeline

**Author:** Sagar Tank  
**Email:** tank.sag@northeastern.edu  

## Overview

Single-end RNA-seq analysis pipeline using FastQC, Trimmomatic, HISAT2, and featureCounts.

## Workflow
```
FASTQ → FastQC → Trimmomatic → HISAT2 → featureCounts
```

## Tools Used

- **FastQC** v0.12.1 - Quality control
- **Trimmomatic** v0.40 - Adapter and quality trimming
- **HISAT2** v2.2.1 - Read alignment
- **featureCounts** v2.1.1 - Gene quantification

## Requirements

- macOS (tested on M1 Pro)
- Conda/Miniforge
- Reference genome: GRCh38
- GTF annotation: Ensembl 106

## Installation
```bash
# Install tools via conda
conda install -c bioconda fastqc trimmomatic hisat2 samtools subread

# Download reference genome
curl -O https://genome-idx.s3.amazonaws.com/hisat/grch38_genome.tar.gz
tar -xzf grch38_genome.tar.gz

# Download GTF annotation
curl -O http://ftp.ensembl.org/pub/release-106/gtf/homo_sapiens/Homo_sapiens.GRCh38.106.gtf.gz
gunzip Homo_sapiens.GRCh38.106.gtf.gz
```

## Usage
```bash
# Place your FASTQ file in data/fastq/
# Run the pipeline
bash rnaseq_pipeline.sh
```

## Results

- **FastQC reports**: `data/*_fastqc.html`
- **Trimmed reads**: `data/demo_trimmed.fastq`
- **Alignment**: `HISAT2/demo_trimmed.bam`
- **Gene counts**: `quants/demo_featurecounts.txt`

## Example Results

From demo dataset (1,250,000 reads):
- Trimming: 94.74% reads retained
- Alignment: 93.98% mapping rate
- Gene assignment: 62.3% (843,012 reads)

## Project Structure
```
rnaseq-pipeline/
├── rnaseq_pipeline.sh    # Main pipeline script
├── data/                 # FastQC reports
├── HISAT2/              # BAM alignment files
└── quants/              # Gene count tables
```

## License

MIT License
