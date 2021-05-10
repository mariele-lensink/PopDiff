load("TG_data_20180606.Rdata")
genes<-read.table("mygenes.txt", header=F)

for(row in 1:nrow(genes)){
    gene_name<-genes$V1[row]
    chr<-genes$V2[row]
    start<-genes$V3[row]
    stop<-genes$V4[row]
    write.table(unique(TG.meta$index[which(TG.genes$"""_log2_batch"""[1,]<median(TG.genes$raw[1,]))]),file=paste(gene_name, "_low.txt", sep=""),col.names = F,row.names = F,quote = 




    #!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

vcf<-args[1]
gff<-read.table(args[2])
output <- args[3]

system(paste0("touch ", output))

for( i in 1:nrow(gff)){
  chr<-gff$V1[i]
  start<-gff$V2[i]
  stop<-gff$V3[i]
  system(paste0("tabix -h ",vcf," ", chr,":",start,"-",stop," > ",vcf,"region.vcf"))
  system(paste0("vcftools --vcf ",vcf,"region.vcf --out ",vcf," --TajimaD 100000000"))
  system(paste0("tail -1 ",vcf,".Tajima.D >>",output)) 
}

