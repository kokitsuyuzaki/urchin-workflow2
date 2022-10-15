library("Seurat")
library("SeuratDisk")
library("velocyto.R")
library("SeuratWrappers")
library("ggplot2")
library("scran")
library("scater")

sample_names <- c("SeaUrchin-scRNA-01", "SeaUrchin-scRNA-02", "SeaUrchin-scRNA-03",
    "SeaUrchin-scRNA-04", "SeaUrchin-scRNA-05", "SeaUrchin-scRNA-06",
    "SeaUrchin-scRNA-07", "SeaUrchin-scRNA-08")

group_names <- c("18hr", "36hr", "96hr", "27hr", "48hr", "72hr", "DAPT_96hr", "TPHMO_96hr")

.stratifySeurat <- function(seurat.integrated, group_names){
    seurat.each1 <- seurat.integrated[,
        which(seurat.integrated@meta.data$sample == group_names[1])]
    seurat.each2 <- seurat.integrated[,
        which(seurat.integrated@meta.data$sample == group_names[2])]
    seurat.each3 <- seurat.integrated[,
        which(seurat.integrated@meta.data$sample == group_names[3])]
    seurat.each4 <- seurat.integrated[,
        which(seurat.integrated@meta.data$sample == group_names[4])]
    seurat.each5 <- seurat.integrated[,
        which(seurat.integrated@meta.data$sample == group_names[5])]
    seurat.each6 <- seurat.integrated[,
        which(seurat.integrated@meta.data$sample == group_names[6])]
    seurat.each7 <- seurat.integrated[,
        which(seurat.integrated@meta.data$sample == group_names[7])]
    seurat.each8 <- seurat.integrated[,
        which(seurat.integrated@meta.data$sample == group_names[8])]
    list(seurat.each1, seurat.each2, seurat.each3, seurat.each4,
        seurat.each5, seurat.each6, seurat.each7, seurat.each8)
}