source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Loading
annotation <- read.xlsx(infile, sheetIndex=1)

# Save
save(annotation, file=outfile)