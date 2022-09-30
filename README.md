# urchin-workflow2
This workflow consists of 11 workflows as follows:

- **workflow/download.smk**: Data downloading

![](https://github.com/kokitsuyuzaki/urchin-workflow2/blob/master/plot/download.png?raw=true)

- **workflow/gtf.smk**: GTF file preprocessing

![](https://github.com/kokitsuyuzaki/urchin-workflow2/blob/master/plot/gtf.png?raw=true)

- **workflow/cellranger.smk**: `CellRanger` mkref and count

![](https://github.com/kokitsuyuzaki/urchin-workflow2/blob/master/plot/cellranger.png?raw=true)

- **workflow/seurat.smk**: `Seurat` against each dataset, data integration, and marker detection

![](https://github.com/kokitsuyuzaki/urchin-workflow2/blob/master/plot/seurat.png?raw=true)

- **workflow/doublet.smk**: Doublet detection by `XXXXXXXXXXXX`

![](https://github.com/kokitsuyuzaki/urchin-workflow2/blob/master/plot/doublet.png?raw=true)

- **workflow/trajectory.smk**: Trajectory inference by `Monocle`

![](https://github.com/kokitsuyuzaki/urchin-workflow2/blob/master/plot/trajectory.png?raw=true)

- **workflow/velocity.smk**: RNA velocity analysis by `Velociraptor`

![](https://github.com/kokitsuyuzaki/urchin-workflow2/blob/master/plot/velocity.png?raw=true)

- **workflow/plot.smk**: Plots against cluster labels (before celltyping)

![](https://github.com/kokitsuyuzaki/urchin-workflow2/blob/master/plot/plot.png?raw=true)

- **workflow/report.smk**: Interactive report by `Pagoda2`

![](https://github.com/kokitsuyuzaki/urchin-workflow2/blob/master/plot/report.png?raw=true)

- **workflow/celltyping.smk**: Celltyping based on manual selection of cluster-specific markers

![](https://github.com/kokitsuyuzaki/urchin-workflow2/blob/master/plot/celltyping.png?raw=true)

- **workflow/plot_aftercelltyping.smk**: Plots against cell type labels (after celltyping)

![](https://github.com/kokitsuyuzaki/urchin-workflow2/blob/master/plot/plot_aftercelltyping.png?raw=true)

## Requirements
- Bash: GNU bash, version 4.2.46(1)-release (x86_64-redhat-linux-gnu)
- Snakemake: 7.1.0
- Singularity: 3.8.0

## How to reproduce this workflow
### In Local Machine

```
snakemake -s workflow/download.smk -j 4 --use-singularity
snakemake -s workflow/gtf.smk -j 4 --use-singularity
snakemake -s workflow/cellranger.smk -j 4 --use-singularity
snakemake -s workflow/seurat.smk -j 4 --use-singularity
snakemake -s workflow/doublet.smk -j 4 --use-singularity
snakemake -s workflow/trajectory.smk -j 4 --use-singularity
snakemake -s workflow/velocity.smk -j 4 --use-singularity
snakemake -s workflow/plot.smk -j 4 --use-singularity
snakemake -s workflow/report.smk -j 4 --use-singularity

snakemake -s workflow/celltyping.smk -j 4 --use-singularity
snakemake -s workflow/plot_aftercelltyping.smk -j 4 --use-singularity
```

### In Open Grid Engine

```
snakemake -s workflow/download.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/gtf.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/cellranger.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/seurat.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/doublet.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/trajectory.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/velocity.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/plot.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/report.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity

snakemake -s workflow/celltyping.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/plot_aftercelltyping.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
```

### In Slurm

```
snakemake -s workflow/download.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/gtf.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/cellranger.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/seurat.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/doublet.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/trajectory.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/velocity.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/plot.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/report.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity

snakemake -s workflow/celltyping.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/plot_aftercelltyping.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
```

## License
Copyright (c) 2022 Koki Tsuyuzaki released under the [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

## Authors
- Koki Tsuyuzaki
- Shunsuke Yaguchi