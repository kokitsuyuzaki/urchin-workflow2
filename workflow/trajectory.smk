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

container: 'docker://koki/urchin_workflow_seurat:20221004'

rule all:
    input:
        expand('output/{db}/{sample}/monocle3.RData',
            db=DBS, sample=SAMPLES),
        expand('output/{db}/integrated/monocle3.RData',
            db=DBS)

#################################
# Monocle3
#################################
rule monocle3:
    input:
        'output/{db}/{sample}/seurat.RData'
    output:
        'output/{db}/{sample}/monocle3.RData'
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLES])
    resources:
        mem_gb=500
    benchmark:
        'benchmarks/monocle3_{db}_{sample}.txt'
    log:
        'logs/monocle3_{db}_{sample}.log'
    shell:
        'src/monocle3.sh {input} {output} >& {log}'

rule monocle3_integrated:
    input:
        'output/{db}/integrated/seurat.RData'
    output:
        'output/{db}/integrated/monocle3.RData'
    resources:
        mem_gb=500
    benchmark:
        'benchmarks/monocle3_{db}_integrated.txt'
    log:
        'logs/monocle3_{db}_integrated.log'
    shell:
        'src/monocle3_integrated.sh {input} {output} >& {log}'
