Calling germline variants from RNA-Seq


Create a directory “Files” to store bam files. This is the output from RNA-Seq pipeline (https://github.com/eshwarmeduri/NGS-Pipelines/tree/main/RNA-Seq)  

**Prior to running GATK pipeline please make sure to add readgroups to the BAM files**

In the current workflow bam files are named with an extension *.dedup.AddRG.bam


1)	Keep nextflow script and nextflow.config in the same folder

2)	Nextflow executable is in /data/Softwares/. Please add this text to .bashrc file. 

export PATH=${PATH}:/data/Softwares/Nextflow

3)	Output files are generated in the current working directory with sub folders named after each sample (For example: Output/Sample1, Output/Sample2……..)

4)	Please note that the current reference genome is hg38 and is accessed from /data/Reference_Genomes also keep the a copy of common variants in the same directory. 


How to run the pipeline:

nextflow run RNASeq-VariantCalling.nf



Important notes: 

•	Please be mindful of the shared resources on the server. Nextflow is designed for parallel processing. So don’t run the pipeline for more than 10 samples at a time. 

•	Nextflow also creates a directory called “work” for all the output files. As the output files are also stored in a directory called Output/, delete the content in directory “work” by typing below commands

o	nextflow clean -f
o	rm -rf work 






