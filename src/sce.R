source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Loading
load(infile)

# Conversion
sce <- as.SingleCellExperiment(seurat.obj)

# Save
saveRDS(sce, file=outfile)
