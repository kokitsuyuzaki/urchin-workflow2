# -*- coding: utf-8 -*-
import sys
import loompy

args = sys.argv

db = args[1]
outfile = args[2]
infiles = ["output/" + db + "/SeaUrchin-scRNA-0" + str(i) + "/velocyto/SeaUrchin-scRNA-0" + str(i) + ".loom" for i in range(1, 9)]

loompy.combine(infiles, outfile, key="Accession")
