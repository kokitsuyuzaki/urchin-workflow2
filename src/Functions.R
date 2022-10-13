library("GSEABase")
library("GO.db")
library("Seurat")
library("sctransform")
library("xlsx")
library("scDblFinder")
library("scran")
library("scater")
library("SeuratWrappers")
library("monocle3")
library("velociraptor")
library("scTGIF")

sample_names <- c("SeaUrchin-scRNA-01", "SeaUrchin-scRNA-02", "SeaUrchin-scRNA-03",
    "SeaUrchin-scRNA-04", "SeaUrchin-scRNA-05", "SeaUrchin-scRNA-06",
    "SeaUrchin-scRNA-07", "SeaUrchin-scRNA-08")

group_names <- c("18hr", "36hr", "96hr", "27hr", "48hr", "72hr", "DAPT_96hr", "TPHMO_96hr")

blacklist_gene <- "Sp-Hrh2_3"

genes_ridgeplot_hpbase <- c("Hp-Pcna", "Hp-Srrm2-like", "Hp-Tpx2L1",
    "Hp-Lbr", "Hp-Map215prh-like", "Hp-Ndc80L")

genes_ridgeplot_echinobase <- c("Sp-Pcna", "Sp-Srrm2", "Sp-Tpx2L1",
    "Sp-Map215prh", "Sp-Ndc80L")

.firstup <- function(x){
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}

.tableToGMT <- function(gotable){
    # GeneSet's List
    gsc <- lapply(unique(gotable$TERM), function(g){
        target <- which(gotable$TERM == g)
        geneIds <- gotable$GENENAME[target]
        GeneSet(setName=g, geneIds)
    })
    GeneSetCollection(gsc)
}

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

.panelPlot <- function(seuratList, group_names, features){
    # Stratify
    gList <- list()
    length(gList) <- length(group_names)
    for(i in seq_along(group_names)){
        gList[[i]] <- FeaturePlot(seuratList[[i]], features=features,
            reduction = "umap", pt.size=2, label.size=6) + labs(title=group_names[i]) + xlim(c(-15,15)) + ylim(c(-15,15))

    }
    names(gList) <- group_names
    gList <- gList[order(names(gList))]
    # Patch work
    (gList[[1]] | gList[[2]] | gList[[3]] | gList[[4]]) / (gList[[5]] | gList[[6]] | gList[[7]] | gList[[8]])
}
