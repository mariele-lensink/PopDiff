load("home/mlensink/rawdata/TG_data_20180606.Rdata")

genes<-read.table("mygenes.txt", header=F)

for(row in 1:nrow(genes)){
    gene_name<-genes$V1[row]
    chr<-genes$V2[row]
    start<-genes$V3[row]
    stop<-genes$V4[row]
    write.table(unique(TG.meta$index[which(TG.genes$log2[1,]<median(TG.genes$log2[1,]))]),file=paste(gene_name, "_low.txt", sep="\t"),col.names = F,row.names = F,quote = F)
    write.table(unique(TG.meta$index[which(TG.genes$log2[1,]>median(TG.genes$log2[1,]))]),file=paste(gene_name, "_high.txt", sep="\t"),col.names = F,row.names = F,quote = F)
}

