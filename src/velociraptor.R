source("src/Functions2.R")

# Parameter
mode <- commandArgs(trailingOnly=TRUE)[1]
infile <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]

# Loading
seurat.obj <- as.Seurat(ReadVelocity(infile))
sce <- as.SingleCellExperiment(seurat.obj)

# Highly Variable Genes
top.hvgs <- getTopHVGs(modelGeneVar(sce), n=2000)

# scVelo via velociraptor
velo.obj <- scvelo(
	list(X=as.matrix(seurat.obj@assays$spliced@counts),
		spliced=as.matrix(seurat.obj@assays$spliced@counts),
		unspliced=as.matrix(seurat.obj@assays$unspliced@counts)),
	subset.row=top.hvgs, mode=mode)

# Save
save(velo.obj, file=outfile)
