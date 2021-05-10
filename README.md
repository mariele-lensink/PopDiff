# PopDiff
PopDiff calculates and compares polymorphisms across a genome between 2 different populations.  

## Background
PopDiff is an automated tool that can calculate and compare the accumulation of SNPS at the feature level throughout an entire genome between 2 populations. PopDiff also provides important population biology statistics to characterize SNPs within each population at the gene feature level. This allows users to create inferences about or within any gene of a given genome. 

## Quickstart
This package is designed around the snakemake workflow system and we recommend using conda
for installing the required packages. User specified input files will be written into the snakefile in locations designated by comments. Future updates will incorporate command line input. Download and run this pipeline using the following series of commands:

```
git clone https://github.com/mariele-lensink/PopDiff.git
conda env create -n popdiff -f PopDiff/requirements.yml
conda activate popdiff
snakemake --snakefile PopDiff/snakefile -j 10
```

## Input Files:
PopDiff requires the following input files.
1. vcf.gz file containing SNP information for the 2 populations
2. Two files with lists of accessions determining populations. Single column text files. (Ex. population1.txt population2.txt)
3. GFF file containing the information for the reference genome.
4. A table containing a list of genes of interest and their corresponding location within the genome. (Example provided: mygenes.txt)

## Workflow
rule compress_index_vcf:

rule index_vcf:


rule filter_vcf:

rule make_gff:

rule count_snps:

rule calc_tajima:

## Output Files:
Format of output was designed for versatility of analysis. PopDiff provides the following output directories:
1. genevcf/           -vcf files for every gene listed in genes of interest input file
2. filteredvcfs/      -vcf files split by gene and population (2 vcf files for every gene of interest)
3. genegffs/          -gff files for every gene of interest
4. lowcounts/         -text files, named by gene of interest, of gene features and their corresponding SNP counts in population 1
5. highcounts/        -text files, named by gene of interest, of gene features and their corresponding SNP counts in population 2
6. tajimasD/          -text files, named by gene of interest and population ID, with Tajima's D statistics for each feature in the gene.

## Notes: 
PopDiff is designed to be iterable, so that the user can feed the pipeline 2 directories (pop1 and pop2) and, as long as the comparing populations are intuitively named using snakemakes wildcard capabilities, the pipeline will iteratively compare multiple population pairs. 
