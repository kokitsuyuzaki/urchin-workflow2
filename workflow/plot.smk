import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("7.1.0")

SAMPLES = ['SeaUrchin-scRNA-01', 'SeaUrchin-scRNA-02', 'SeaUrchin-scRNA-03',
    'SeaUrchin-scRNA-04', 'SeaUrchin-scRNA-05', 'SeaUrchin-scRNA-06',
    'SeaUrchin-scRNA-07', 'SeaUrchin-scRNA-08']
DBS = ['hpbase', 'echinobase']

container: 'docker://satijalab/seurat:4.1.0'

rule all:
    input:
        expand('plot/{db}/{sample}/dimplot.png',
            sample=SAMPLES, db=DBS),
        expand('plot/{db}/integrated/dimplot_groupby.png',
            db=DBS),
        expand('plot/{db}/integrated/dimplot_splitby.png',
            db=DBS)

rule dimplot:
    input:
        'output/{db}/{sample}/seurat.RData'
    output:
        'plot/{db}/{sample}/dimplot.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/dimplot_{db}_{sample}.txt'
    log:
        'logs/dimplot_{db}_{sample}.log'
    shell:
        'src/dimplot.sh {input} {output} >& {log}'

# rule dimplot_integrated:
#     input:
#         'output/{db}/integrated/seurat.RData'
#     output:
#         'plot/{db}/integrated/dimplot_groupby.png',
#         'plot/{db}/integrated/dimplot_splitby.png'
#     resources:
#         mem_gb=100
#     benchmark:
#         'benchmarks/dimplot_integrated_{db}_integrated.txt'
#     log:
#         'logs/dimplot_integrated_{db}_integrated.log'
#     shell:
#         'src/dimplot_integrated.sh {input} {output} >& {log}'

# VlnPlot（nFeature_RNA, nCount_RNA, percent.mt）

# FeaturePlot（*）

# DoHeatmap
