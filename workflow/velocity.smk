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

MODES = ['steady_state', 'deterministic', 'stochastic', 'dynamical']

rule all:
    input:
        expand('output/{db}/{sample}/velociraptor_{mode}.RData',
            db=DBS, sample=SAMPLES, mode=MODES),
        expand('output/{db}/aggr/velociraptor_{mode}.RData',
            db=DBS, sample=SAMPLES, mode=MODES)

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
# Calculte RNA Velocity
#################################
# rule scvelo:
#     input:
#         'output/{db}/{sample}/velocyto/{sample}.loom'
#     output:
#         'output/{db}/{sample}/velociraptor_{mode}.RData'
#     wildcard_constraints:
#         sample='|'.join([re.escape(x) for x in SAMPLES])
#     container:
#         'docker://koki/velocytor:20221006'
#     resources:
#         mem_gb=500
#     benchmark:
#         'benchmarks/velociraptor_{db}_{sample}_{mode}.txt'
#     log:
#         'logs/velociraptor_{db}_{sample}_{mode}.log'
#     shell:
#         'src/velociraptor.sh {wildcards.mode} {input} {output} >& {log}'

rule velociraptor:
    input:
        'output/{db}/{sample}/velocyto/{sample}.loom'
    output:
        'output/{db}/{sample}/velociraptor_{mode}.RData'
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLES])
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

rule velociraptor_aggr:
    input:
        'output/{db}/aggr/velocyto/aggr.loom'
    output:
        'output/{db}/aggr/velociraptor_{mode}.RData'
    container:
        'docker://koki/velocytor:20221006'
    resources:
        mem_gb=500
    benchmark:
        'benchmarks/velociraptor_aggr_{db}_aggr_{mode}.txt'
    log:
        'logs/velociraptor_aggr_{db}_aggr_{mode}.log'
    shell:
        'src/velociraptor.sh {wildcards.mode} {input} {output} >& {log}'
