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

container: 'docker://litd/docker-cellranger:v7.0.0'

rule all:
    input:
        expand('output/{db}/{sample}/outs/web_summary.html',
            sample=SAMPLES, db=DBS)

#################################
# Cell Ranger Mkref
#################################
rule cellranger_mkref_hpbase:
    input:
        'data/hpbase/trim.HpulGenome_v1.gtf',
        'data/hpbase/HpulGenome_v1_scaffold.fa'
    output:
        'data/hpbase/HpulGenome_v1/star/SA'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/cellranger_mkref_hpbase.txt'
    log:
        'logs/cellranger_mkref_hpbase.log'
    shell:
        'src/cellranger_mkref_hpbase.sh {input} {output} >& {log}'

rule cellranger_mkref_echinobase:
    input:
        'data/echinobase/trim.sp5_0_GCF.gtf',
        'data/echinobase/sp5_0_GCF_genomic.fa'
    output:
        'data/echinobase/sp5_0/star/SA'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/cellranger_mkref_echinobase.txt'
    log:
        'logs/cellranger_mkref_echinobase.log'
    shell:
        'src/cellranger_mkref_echinobase.sh {input} {output} >& {log}'

#################################
# Cell Ranger Count
#################################
rule cellranger_count_hpbase:
    input:
        'data/Shimoda/novaseq_run_original/{sample}'
    output:
        'output/hpbase/{sample}/outs/web_summary.html'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/cellranger_count_hpbase_{sample}.txt'
    log:
        'logs/cellranger_count_hpbase_{sample}.log'
    shell:
        'src/cellranger_count_hpbase.sh {wildcards.sample} >& {log}'

rule cellranger_count_echinobase:
    input:
        'data/Shimoda/novaseq_run_original/{sample}'
    output:
        'output/echinobase/{sample}/outs/web_summary.html'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/cellranger_count_echinobase_{sample}.txt'
    log:
        'logs/cellranger_count_echinobase_{sample}.log'
    shell:
        'src/cellranger_count_echinobase.sh {wildcards.sample} >& {log}'
