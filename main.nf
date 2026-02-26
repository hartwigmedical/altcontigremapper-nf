#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process ALTCONTIGREMAPPER {
    tag "${sample_id}"
    label 'process_high'

    container 'quay.io/biocontainers/hmftools-bam-tools:1.5--hdfd78af_0'

    publishDir "${params.outdir}/${sample_id}", mode: 'copy'

    input:
    tuple val(sample_id), path(bam), path(bai)
    path genome_fasta
    path genome_fasta_img

    output:
    tuple val(sample_id), path("${sample_id}.remapped.bam"), path("${sample_id}.remapped.bam.bai"), emit: bam

    script:
    """
    bamtools \\
        -Xmx${Math.round(task.memory.bytes * 0.75)} \\
        com.hartwig.hmftools.bamtools.remapper.AltContigRemapper \\
        -orig_bam_file ${bam} \\
        -ref_genome ${genome_fasta} \\
        -output_file ${sample_id}.remapped.bam \\
        -bamtool ${params.samtools_path} \\
        -threads ${task.cpus}
    """
}

workflow {
    if (!params.input)        { error "Please provide --input samplesheet.csv" }
    if (!params.genome_fasta) { error "Please provide --genome_fasta /path/to/ref.fa" }

    channel
        .fromPath(params.input)
        .splitCsv(header: true)
        .map { row -> [row.sample_id, file(row.bam), file(row.bai)] }
        .set { ch_samples }

    ALTCONTIGREMAPPER(ch_samples, file(params.genome_fasta), file("${params.genome_fasta}.img"))
}
