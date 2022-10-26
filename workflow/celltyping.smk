import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("6.5.3")

SAMPLES = ['SeaUrchin-scRNA-01', 'SeaUrchin-scRNA-02', 'SeaUrchin-scRNA-03',
    'SeaUrchin-scRNA-04', 'SeaUrchin-scRNA-05', 'SeaUrchin-scRNA-06',
    'SeaUrchin-scRNA-07', 'SeaUrchin-scRNA-08']

rule all:
    input:
        expand('plot/hpbase/{sample}/dimplot_celltype.png', sample=SAMPLES),
        'plot/hpbase/integrated/dimplot_celltype.png',
        'plot/hpbase/integrated/dimplot_celltype_splitby.png',
        expand('plot/hpbase/{sample}/dotplot_celltype.png', sample=SAMPLES),
        'plot/hpbase/integrated/dotplot_celltype.png',
        'plot/hpbase/integrated/dotplot_celltype_splitby.png'

#################################
# Celltype Label
#################################
rule celltype_label:
    input:
        'output/hpbase/{sample}/seurat.RData',
        'data/Shimoda/cluster_celltype.xlsx'
    output:
        'output/hpbase/{sample}/seurat_celltype.RData'
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLES])
    container:
        'docker://koki/urchin_workflow_seurat:20221013'
    resources:
        mem_gb=1000
    benchmark:
        'benchmarks/celltype_label_hpbase_{sample}.txt'
    log:
        'logs/celltype_label_hpbase_{sample}.log'
    shell:
        'src/celltype_label.sh {input} {output} >& {log}'

rule celltype_label_integrated:
    input:
        'output/hpbase/integrated/seurat.RData',
        'data/Shimoda/cluster_celltype.xlsx'
    output:
        'output/hpbase/integrated/seurat_celltype.RData'
    container:
        'docker://koki/urchin_workflow_seurat:20221013'
    resources:
        mem_gb=1000
    benchmark:
        'benchmarks/celltype_label_integrated_hpbase_integrated.txt'
    log:
        'logs/celltype_label_integrated_hpbase_integrated.log'
    shell:
        'src/celltype_label_integrated.sh {input} {output} >& {log}'

#################################
# Dimplot
#################################
rule dimplot_celltype:
    input:
        'output/hpbase/{sample}/seurat_celltype.RData'
    output:
        'plot/hpbase/{sample}/dimplot_celltype.png'
    container:
        'docker://koki/urchin_workflow_seurat:20221013'
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLES])
    resources:
        mem_gb=1000
    benchmark:
        'benchmarks/dimplot_celltype_hpbase_{sample}.txt'
    log:
        'logs/dimplot_celltype_hpbase_{sample}.log'
    shell:
        'src/dimplot_celltype.sh {input} {output} >& {log}'

rule dimplot_celltype_integrated:
    input:
        'output/hpbase/integrated/seurat_celltype.RData'
    output:
        'plot/hpbase/integrated/dimplot_celltype.png',
        'plot/hpbase/integrated/dimplot_celltype_splitby.png'
    container:
        'docker://koki/urchin_workflow_seurat:20221013'
    resources:
        mem_gb=1000
    benchmark:
        'benchmarks/dimplot_celltype_integrated_hpbase_integrated.txt'
    log:
        'logs/dimplot_celltype_integrated_hpbase_integrated.log'
    shell:
        'src/dimplot_celltype_integrated.sh {input} {output} >& {log}'

#################################
# Dotplot
#################################
rule dotplot_celltype:
    input:
        'output/hpbase/{sample}/seurat_celltype.RData'
    output:
        'plot/hpbase/{sample}/dotplot_celltype.png'
    container:
        'docker://koki/urchin_workflow_seurat:20221013'
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLES])
    resources:
        mem_gb=1000
    benchmark:
        'benchmarks/dotplot_celltype_hpbase_{sample}.txt'
    log:
        'logs/dotplot_celltype_hpbase_{sample}.log'
    shell:
        'src/dotplot_celltype.sh {input} {output} >& {log}'

rule dotplot_celltype_integrated:
    input:
        'output/hpbase/integrated/seurat_celltype.RData'
    output:
        'plot/hpbase/integrated/dotplot_celltype.png',
        'plot/hpbase/integrated/dotplot_celltype_splitby.png'
    container:
        'docker://koki/urchin_workflow_seurat:20221013'
    resources:
        mem_gb=1000
    benchmark:
        'benchmarks/dotplot_celltype_integrated_hpbase_integrated.txt'
    log:
        'logs/dotplot_celltype_integrated_hpbase_integrated.log'
    shell:
        'src/dotplot_celltype_integrated.sh {input} {output} >& {log}'