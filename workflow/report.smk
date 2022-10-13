import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("6.5.3")

SAMPLES = ['SeaUrchin-scRNA-01', 'SeaUrchin-scRNA-02', 'SeaUrchin-scRNA-03',
    'SeaUrchin-scRNA-04', 'SeaUrchin-scRNA-05', 'SeaUrchin-scRNA-06',
    'SeaUrchin-scRNA-07', 'SeaUrchin-scRNA-08']

DBS = ['hpbase', 'echinobase']

GOS = ['bp', 'mf', 'cc']

container: 'docker://koki/urchin_workflow_seurat:20221013'

rule all:
    input:
        expand('plot/{db}/{sample}/scTGIF/{go}/index.html',
            db=DBS, sample=SAMPLES, go=GOS),
        expand('plot/{db}/integrated/scTGIF/{go}/index.html',
            db=DBS, go=GOS)

#################################
# Functional Annotation
#################################
rule sctgif:
    input:
        'output/{db}/{sample}/seurat.RData',
        'data/go_{go}_{db}.RData'
    output:
        'plot/{db}/{sample}/scTGIF/{go}/index.html'
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLES])
    resources:
        mem_gb=500
    benchmark:
        'benchmarks/sctgif_{db}_{sample}_{go}.txt'
    log:
        'logs/sctgif_{db}_{sample}_{go}.log'
    shell:
        'src/sctgif.sh {wildcards.db} {wildcards.go} {input} {output} >& {log}'

rule sctgif_integrated:
    input:
        'output/{db}/integrated/seurat.RData',
        'data/go_{go}_{db}.RData'
    output:
        'plot/{db}/integrated/scTGIF/{go}/index.html'
    resources:
        mem_gb=500
    benchmark:
        'benchmarks/sctgif_{db}_integrated_{go}.txt'
    log:
        'logs/sctgif_{db}_integrated_{go}.log'
    shell:
        'src/sctgif_integrated.sh {wildcards.db} {wildcards.go} {input} {output} >& {log}'
