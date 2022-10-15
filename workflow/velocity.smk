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

MODES = ['deterministic', 'stochastic', 'dynamical']

rule all:
    input:
        expand('output/{db}/{sample}/velocyto/{sample}_{mode}.h5ad',
            db=DBS, sample=SAMPLES, mode=MODES),
        expand('output/{db}/integrated/velocyto/integrated_{mode}.h5ad',
            db=DBS, mode=MODES)

#################################
# Generate Loom files
#################################
rule velocyto:
    input:
        'output/hpbase/{sample}/outs/web_summary.html',
        'data/hpbase/HpulGenome_v1_geneid.gtf',
        'output/echinobase/{sample}/outs/web_summary.html',
        'data/echinobase/sp5_0_GCF_geneid.gtf'
    output:
        'output/{db}/{sample}/velocyto/{sample}.loom'
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLES])
    container:
        'docker://koki/velocyto:20221005'
    resources:
        mem_gb=500
    benchmark:
        'benchmarks/velocyto_{db}_{sample}.txt'
    log:
        'logs/velocyto_{db}_{sample}.log'
    shell:
        'src/velocyto.sh {wildcards.db} {wildcards.sample} >& {log}'

#################################
# Aggregate Loom files
#################################
def aggregate_sample(db):
    out = []
    for j in range(len(SAMPLES)):
        out.append('output/' + db[0] + '/' + SAMPLES[j] + '/velocyto/' + SAMPLES[j] + '.loom')
    return(out)

rule aggr_loom:
    input:
        aggregate_sample
    output:
        'output/{db}/aggr/velocyto/aggr.loom'
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLES])
    container:
        'docker://koki/velocyto:20221005'
    resources:
        mem_gb=500
    benchmark:
        'benchmarks/aggr_loom_{db}.txt'
    log:
        'logs/aggr_loom_{db}.log'
    shell:
        'src/aggr_loom.sh {wildcards.db} {output} >& {log}'

#################################
# Seurat => AnnData
#################################
rule seurat2anndata:
    input:
        'output/{db}/{sample}/seurat.RData'
    output:
        'output/{db}/{sample}/seurat.h5ad'
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLES])
    container:
        'docker://koki/velocytor:20221015'
    resources:
        mem_gb=500
    benchmark:
        'benchmarks/seurat2anndata_{db}_{sample}.txt'
    log:
        'logs/seurat2anndata_{db}_{sample}.log'
    shell:
        'src/seurat2anndata.sh {input} {output} >& {log}'

rule seurat2anndata_integrated:
    input:
        'output/{db}/integrated/seurat.RData'
    output:
        'output/{db}/integrated/seurat.h5ad'
    container:
        'docker://koki/velocytor:20221015'
    resources:
        mem_gb=500
    benchmark:
        'benchmarks/seurat2anndata_{db}_integrated.txt'
    log:
        'logs/seurat2anndata_{db}_integrated.log'
    shell:
        'src/seurat2anndata_integrated.sh {input} {output} >& {log}'

#################################
# Calculte RNA Velocity
#################################
rule scvelo:
    input:
        'output/{db}/{sample}/velocyto/{sample}.loom',
        'output/{db}/{sample}/seurat.h5ad'
    output:
        'output/{db}/{sample}/velocyto/{sample}_{mode}.h5ad'
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLES])
    container:
        'docker://koki/velocyto:20221005'
    resources:
        mem_gb=500
    benchmark:
        'benchmarks/scvelo_{db}_{sample}_{mode}.txt'
    log:
        'logs/scvelo_{db}_{sample}_{mode}.log'
    shell:
        'src/scvelo.sh {wildcards.mode} {input} {output} >& {log}'

rule scvelo_integrated:
    input:
        'output/{db}/aggr/velocyto/aggr.loom',
        'output/{db}/integrated/seurat.h5ad'
    output:
        'output/{db}/integrated/velocyto/integrated_{mode}.h5ad'
    container:
        'docker://koki/velocyto:20221005'
    resources:
        mem_gb=500
    benchmark:
        'benchmarks/scvelo_{db}_integrated_{mode}.txt'
    log:
        'logs/scvelo_{db}_integrated_{mode}.log'
    shell:
        'src/scvelo.sh {wildcards.mode} {input} {output} >& {log}'