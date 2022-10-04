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

group_names <- c("18hr", "36hr", "96hr", "27hr",
    "48hr", "72hr", "DAPT_96hr", "TPHMO_96hr")

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

