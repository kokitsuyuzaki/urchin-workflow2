source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Loading
marker1 <- read.xlsx(infile, sheetIndex=1)
marker2 <- read.xlsx(infile, sheetIndex=2)

# Preprocessing
marker <- rbind(marker1, marker2)
marker <- marker[, 1:3]
target1 <- which(!is.na(marker[, 2]))
target2 <- which(!is.na(marker[, 3]))
target <- union(target1, target2)
marker <- marker[target, ]
marker <- cbind(marker, paste0("Hp-", marker$genes), paste0("Sp-", marker$genes))
colnames(marker) <- c("GENENAME", "GENEID_Hp", "GENEID_Sp", "GENENAME_Hp", "GENENAME_Sp")

# Save
save(marker, file=outfile)
