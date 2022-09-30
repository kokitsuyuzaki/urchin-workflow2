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

container: 'docker://koki/urchin_workflow_seurat:20220930'

rule all:
    input:
        expand('output/{db}/{sample}/markers.xlsx',
            db=DBS, sample=SAMPLES),
        expand('output/{db}/integrated/markers.xlsx',
            db=DBS)

#################################
# Corresponding Table for ID conversion
#################################
rule geneid_to_genename:
    input:
        'data/hpbase/HpulGenome_v1_annot.xlsx'
    output:
        'data/geneid_to_genename.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/geneid_to_genename.txt'
    log:
        'logs/geneid_to_genename.log'
    shell:
        'src/geneid_to_genename.sh {input} {output} >& {log}'

#################################
# Seurat
#################################
rule seurat:
    input:
        'data/geneid_to_genename.csv',
        'output/{db}/{sample}/outs/web_summary.html'
    output:
        'output/{db}/{sample}/seurat.RData'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/seurat_{db}_{sample}.txt'
    log:
        'logs/seurat_{db}_{sample}.log'
    shell:
        'src/seurat.sh {wildcards.db} {wildcards.sample} {output} >& {log}'

def aggregate_sample(db):
    out = []
    for j in range(len(SAMPLES)):
        out.append('output/' + db[0] + '/' + SAMPLES[j] + '/seurat.RData')
    return(out)

rule seurat_integration:
    input:
        aggregate_sample
    output:
        'output/{db}/integrated/seurat.RData'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/seurat_{db}_integrated.txt'
    log:
        'logs/seurat_{db}_integrated.log'
    shell:
        'src/seurat_integration.sh {wildcards.db} {output} >& {log}'

rule seurat_findmarkers:
    input:
        'output/{db}/{sample}/seurat.RData'
    output:
        'output/{db}/{sample}/markers.xlsx'
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLES])
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/seurat_findmarkers_{db}_{sample}.txt'
    log:
        'logs/seurat_findmarkers_{db}_{sample}.log'
    shell:
        'src/seurat_findmarkers.sh {input} {output} >& {log}'

rule seurat_findconservedmarkers:
    input:
        'output/{db}/integrated/seurat.RData'
    output:
        'output/{db}/integrated/markers.xlsx'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/seurat_findconservedmarkers_{db}_integrated.txt'
    log:
        'logs/seurat_findconservedmarkers_{db}_integrated.log'
    shell:
        'src/seurat_findconservedmarkers.sh {input} {output} >& {log}'
