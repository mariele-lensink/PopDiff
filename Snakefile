import pandas as pd
geneInfo = pd.read_csv("mygenesTEST.txt", sep="\t", names=["geneid","genename", "chrom", "start", "stop"])
geneInfo.set_index("geneid",inplace=True)
idlist = geneInfo['genename'].tolist()
print(idlist)

rule all:
    input: low = expand("lowcounts/{geneid}_low.counts.txt",geneid = idlist), high =expand("highcounts/{geneid}_high.counts.txt",geneid = idlist), tajima_low = expand("tajimasD/{geneid}_low.Tajima.D",geneid = idlist), tajima_high = expand("tajimasD/{geneid}_high.Tajima.D",geneid = idlist)

rule compress_index_vcf:
    input:
        "1001genomes_snp-short-indel_only_ACGTN.vcf.gz"
    output:
        genevcf = "genevcf/{geneid}.vcf",
        zipped = "genevcf/{geneid}.vcf.gz"
    params:
        chrom = lambda w: geneInfo.at[w.geneid, "chrom"],
        start = lambda w: geneInfo.at[w.geneid, "start"],
        stop = lambda w: geneInfo.at[w.geneid, "stop"]
    shell: """
        tabix -h {input} {params.chrom}:{params.start}-{params.stop} > {output.genevcf}
        bgzip -stdout {output.genevcf} > {output.zipped}

"""

rule index_vcf:
        input:
                genevcf = "genevcf/{geneid}.vcf.gz"
        output:
                index = "genevcf/{geneid}.vcf.gz.tbi"
        shell: """
                tabix {input.genevcf}
        """

rule filter_vcf:
    input:
        genesnvs = "genevcf/{geneid}.vcf.gz",
        low ="/home/mlensink/mutationrateproj/splitaccessions/{geneid}_low.txt",
        high ="/home/mlensink/mutationrateproj/splitaccessions/{geneid}_high.txt",
        index = "genevcf/{geneid}.vcf.gz.tbi"
    output:
        low = "filteredvcfs/{geneid}_low.vcf",
        high = "filteredvcfs/{geneid}_high.vcf",
        lowzip = "filteredvcfs/{geneid}_low.vcf.gz",
        highzip = "filteredvcfs/{geneid}_high.vcf.gz"
    shell: """
        bcftools view --force-samples -q 0.00001 -S {input.low} {input.genesnvs} > {output.low}
        bcftools view --force-samples -q 0.00001 -S {input.high} {input.genesnvs} > {output.high}
        bgzip -stdout {output.low} > {output.lowzip}
        bgzip -stdout {output.high} > {output.highzip}
        tabix {output.lowzip}
        tabix {output.highzip}
        """

rule make_gff:
    input:
        "TAIR10.gff"
    output:
        genegff ="genegffs/{geneid}.gff"
    params:
        genename = lambda w: geneInfo.at[w.geneid, "genename"]
    shell:"""
        grep {params.genename} TAIR10.gff > {output.genegff}
    """

rule count_snps:
        input:
                gff = "genegffs/{geneid}.gff",
                low = "filteredvcfs/{geneid}_low.vcf.gz",
                high = "filteredvcfs/{geneid}_high.vcf.gz"
        output:
                low = "lowcounts/{geneid}_low.counts.txt",
                high = "highcounts/{geneid}_high.counts.txt"
        shell: """
        bedtools coverage -counts -a {input.gff} -b {input.low} > {output.low}
        bedtools coverage -counts -a {input.gff} -b {input.high} > {output.high}
    """

rule calc_tajima:
        input:
                low = "filteredvcfs/{geneid}_low.vcf.gz",
                high = "filteredvcfs/{geneid}_high.vcf.gz",
                gff = "genegffs/{geneid}.gff"
        output:
                low = "tajimasD/{geneid}_low.Tajima.D",
                high = "tajimasD/{geneid}_high.Tajima.D"
        params:
                genename = lambda w: geneInfo.at[w.geneid, "genename"]

        shell: """
                Rscript calctajima.R {input.low} {input.gff} tajimasD/{params.genename}_low.Tajima.D
                Rscript calctajima.R {input.high} {input.gff} tajimasD/{params.genename}_high.Tajima.D
"""