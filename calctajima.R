#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

vcf<-args[1]
gff<-read.table(args[2])
output <- args[3]

system(paste0("touch ", output))

for( i in 1:nrow(gff))
{
  chr<-gff$V1[i]
  start<-gff$V2[i]
  stop<-gff$V3[i]
  system(paste0("tabix -h ",vcf," ",chr,":",start,"-",stop," > ",vcf,"region.vcf"))
  system(paste0("vcftools --vcf ",vcf,"region.vcf --out ",vcf," --TajimaD 100000000"))
  system(paste0("tail -1 ",vcf,".Tajima.D >>",output))
}
