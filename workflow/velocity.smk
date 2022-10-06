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

MODES = ['steady_state', 'deterministic', 'stochastic']

rule all:
    input:
        expand('output/{db}/{sample}/velociraptor_{mode}.RData',
            db=DBS, sample=SAMPLES, mode=MODES)

#################################
# Generate Loom files
#################################
rule velocyto_hpbase:
    input:
        'output/hpbase/{sample}/outs/web_summary.html',
        'data/hpbase/HpulGenome_v1_geneid.gtf'
    output:
        'output/hpbase/{sample}/velocyto/{sample}.loom'
    container:
        'docker://koki/velocyto:20221005'
    resources:
        mem_gb=500
    benchmark:
        'benchmarks/velocyto_hpbase_{sample}.txt'
    log:
        'logs/velocyto_hpbase_{sample}.log'
    shell:
        'src/velocyto.sh hpbase {wildcards.sample} >& {log}'

rule velocyto_echinobase:
    input:
        'output/echinobase/{sample}/outs/web_summary.html',
        'data/echinobase/sp5_0_GCF_geneid.gtf'
    output:
        'output/echinobase/{sample}/velocyto/{sample}.loom'
    container:
        'docker://koki/velocyto:20221005'
    resources:
        mem_gb=500
    benchmark:
        'benchmarks/velocyto_echinobase_{sample}.txt'
    log:
        'logs/velocyto_echinobase_{sample}.log'
    shell:
        'src/velocyto.sh echinobase {wildcards.sample} >& {log}'

#################################
# Generate Loom files
#################################
rule velociraptor:
    input:
        'output/{db}/{sample}/velocyto/{sample}.loom'
    output:
        'output/{db}/{sample}/velociraptor_{mode}.RData'
    container:
        'docker://koki/velocytor:20221006'
    resources:
        mem_gb=500
    benchmark:
        'benchmarks/velociraptor_{db}_{sample}_{mode}.txt'
    log:
        'logs/velociraptor_{db}_{sample}_{mode}.log'
    shell:
        'src/velociraptor.sh {wildcards.mode} {input} {output} >& {log}'
