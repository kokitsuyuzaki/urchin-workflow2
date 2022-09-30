source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Loading
load(infile)

# Marker detection
seurat_clusters <- seurat.obj@meta.data$seurat_clusters
for(i in seq(nlevels(seurat_clusters))){
    tmp <- FindMarkers(seurat.obj, ident.1=levels(seurat_clusters)[i])
    # Save
    sheetname <- paste0("cluster", i)
    if(i == 1){
        write.xlsx(tmp, file=outfile, sheetName=sheetname)
    }else{
        write.xlsx(tmp, file=outfile, sheetName=sheetname, append=TRUE)
    }
}
