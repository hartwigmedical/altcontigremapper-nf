# AltContigRemapper-nf

Nextflow DSL2 pipeline that remaps BAM file alignments to alternative contigs for HLA-typing using Hartwig Medical Foundation's [bamtools AltContigRemapper](https://github.com/hartwigmedical/hmftools/tree/master/bam-tools).

## Usage

```bash
nextflow run main.nf --input samplesheet.csv --genome_fasta /path/to/ref.fa --outdir results
```

| Parameter | Description | Default |
|---|---|---|
| `--input` | CSV samplesheet with columns `sample_id,bam,bai` | required |
| `--genome_fasta` | Reference genome FASTA | required |
| `--outdir` | Output directory | `results` |

See [samplesheet.example.csv](samplesheet.example.csv) for the expected input format.

## Requirements

- [Nextflow](https://www.nextflow.io/) (DSL2)
- [Singularity](https://sylabs.io/singularity/) (configured by default) or Docker
