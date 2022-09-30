source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Loading
load(infile)









# dimplot.Rのパラメーターも参考
# Plot
png(file=outfile, width=600, height=600)

p1 <- DimPlot(seurat.integrated, reduction = "umap", group.by="sample")
p2 <- DimPlot(seurat.integrated, reduction = "umap")
p1 + p2

p3 <- DimPlot(seurat.integrated, reduction = "umap", split.by="sample", ncol=4)


DimPlot(seurat.obj, label=TRUE, pt.size=2, label.size=6)
dev.off()
