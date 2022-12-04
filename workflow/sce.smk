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

container: 'docker://koki/urchin_workflow_seurat:20221013'

rule all:
    input:
        expand('output/{db}/{sample}/sce.rds',
            db=DBS, sample=SAMPLES),
        expand('output/{db}/integrated/sce.rds',
            db=DBS)

rule sce:
    input:
        'output/{db}/{sample}/seurat.RData'
    output:
        'output/{db}/{sample}/sce.rds'
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLES])
    resources:
        mem_gb=1000
    benchmark:
        'benchmarks/sce_{db}_{sample}.txt'
    log:
        'logs/sce_{db}_{sample}.log'
    shell:
        'src/sce.sh {input} {output} >& {log}'

rule sce_integrated:
    input:
        'output/{db}/integrated/seurat.RData'
    output:
        'output/{db}/integrated/sce.rds'
    resources:
        mem_gb=1000
    benchmark:
        'benchmarks/sce_integrated_{db}.txt'
    log:
        'logs/sce_integrated_{db}z.log'
    shell:
        'src/sce_integrated.sh {input} {output} >& {log}'
