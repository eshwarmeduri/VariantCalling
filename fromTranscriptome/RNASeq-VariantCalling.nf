#!/usr/bin/env nextflow -DSL2

params.bam = "$baseDir/Files/*.dedup.AddRG.bam" //$baseDir is the current working directory
genome="/tmp/GRCh38.d1.vd1.fa" //hg38 reference genome. 
params.results_dir = "$baseDir/Output/"
params.cores=1
vcfFile='/tmp/common_all_20180418_SNPs_withChrNames.vcf.gz' //VCF file of known snps

workflow {

    bamFile_ch = Channel.fromPath( params.bam, checkIfExists: true)

    gatk_ch = GATKALL (bamFile_ch) //All the steps are included in this workflow whicg generates the final VCF file

}

process GATKALL {

    publishDir "Output/${bam_file.baseName}", mode: 'copy', overwrite: true

    input:
    
    path bam_file
    
    output:

    path ("*")
    
    script:
    """
    /gatk/gatk SplitNCigarReads -R ${genome} -I ${bam_file} -O ${bam_file.baseName}.Split-MQFalse.bam
    /gatk/gatk BaseRecalibrator -R ${genome} -I ${bam_file.baseName}.Split-MQFalse.bam -O ${bam_file.baseName}_recal_pass1.tabl --known-sites ${vcfFile}
    /gatk/gatk ApplyBQSR -R ${genome} -I ${bam_file.baseName}.Split-MQFalse.bam --bqsr-recal-file ${bam_file.baseName}_recal_pass1.tabl -O ${bam_file.baseName}_recal_pass1.bam
    /gatk/gatk HaplotypeCaller --native-pair-hmm-threads $params.cores -R ${genome} -I ${bam_file.baseName}_recal_pass1.bam --dont-use-soft-clipped-bases true -stand-call-conf 20.0 -O ${bam_file.baseName}_recal_pass1.vcf
    /gatk/gatk VariantFiltration -R ${genome} -V ${bam_file.baseName}_recal_pass1.vcf -window 35 -cluster 3 --filter-name FS --filter-expression "FS > 30.0" --filter-name QD --filter-expression "QD < 2.0" -O ${bam_file.baseName}_recal_pass1_VarFilter.vcf


    """
}

