# -*- coding: utf-8 -*-
import sys
import scvelo as scv
import scanpy
import pandas as pd
import numpy as np

args = sys.argv
mode = args[1]
infile1 = args[2]
infile2 = args[3]
outfile = args[4]

# Loading
adata1 = scv.read(infile1)
adata2 = scanpy.read_h5ad(infile2)

# Assign PCA, UMAP, and cluster ID calculated by Seurat
adata1.obs['clusters'] = pd.Categorical(adata2.obs['seurat_clusters'])
adata1.obsm['X_pca'] = adata2.obsm['X_pca']
adata1.obsm['X_umap'] = adata2.obsm['X_umap']

# Trimming cluster 0, 2, 8, and 26
a = set(np.where(adata1.obs['clusters'] != 0)[0])
b = set(np.where(adata1.obs['clusters'] != 2)[0])
c = set(np.where(adata1.obs['clusters'] != 8)[0])
d = set(np.where(adata1.obs['clusters'] != 26)[0])
target = list(a.intersection(b).intersection(c).intersection(d))
adata1 = adata1[target, :]

# Preprocessing
scv.pp.filter_genes(adata1, min_shared_counts=20)
scv.pp.normalize_per_cell(adata1)
scv.pp.filter_genes_dispersion(adata1, n_top_genes=2000)
scv.pp.log1p(adata1)
scv.pp.filter_and_normalize(adata1, min_shared_counts=20, n_top_genes=2000)
scv.pp.moments(adata1, n_pcs=30, n_neighbors=30)

# RNA Velocity
scv.tl.velocity(adata1, mode=mode)

# Velocity Graph
scv.tl.velocity_graph(adata1)

# Latent Time
if mode == "dynamical":
    scv.tl.recover_dynamics(adata1)
    scv.tl.latent_time(adata1)

# Save
adata1.write(outfile)
