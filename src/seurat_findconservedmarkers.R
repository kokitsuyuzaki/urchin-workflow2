source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Loading
load(infile)

# Marker detection
seurat_clusters <- seurat.integrated@meta.data$seurat_clusters
for(i in seq(nlevels(seurat_clusters))){
    tmp <- FindConservedMarkers(seurat.integrated,
        ident.1=levels(seurat_clusters)[i], grouping.var = "sample")
    # Save
    sheetname <- paste0("cluster", i)
    if(i == 1){
        write.xlsx(tmp, file=outfile, sheetName=sheetname)
    }else{
        write.xlsx(tmp, file=outfile, sheetName=sheetname, append=TRUE)
    }
}
