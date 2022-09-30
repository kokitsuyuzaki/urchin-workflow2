library("Seurat")
library("sctransform")
library("xlsx")
library("scTGIF")
library("velociraptor")
library("pagoda2")
library("SeuratWrappers")
library("monocle3")
library("DoubletFinder")

sample_names <- c("SeaUrchin-scRNA-01", "SeaUrchin-scRNA-02", "SeaUrchin-scRNA-03",
    "SeaUrchin-scRNA-04", "SeaUrchin-scRNA-05", "SeaUrchin-scRNA-06",
    "SeaUrchin-scRNA-07", "SeaUrchin-scRNA-08")

group_names <- c("18hr", "36hr", "96hr", "27hr",
    "48hr", "72hr", "DAPT_96hr", "TPHMO_96hr")

blacklist_gene <- "Sp-Hrh2_3"

s_genes <- c("XXXX", "XXXXX")

g2m_genes <- c("XXXX", "XXXXX")

