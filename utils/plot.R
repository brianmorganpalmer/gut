#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#library(Maaslin)
#library(gamlss)
#library(grid)
library('pheatmap')



source('/Users/rah/Documents/Hutlab/american_gut/utils/r_utils.R')
#print(args[1])
#output_path = paste(args[3],"/MODULE.pdf", sep="")
#print(output_path)
#maaslin_heatmap(title ="Metabolomic Modules vs Metadata ", maaslin_output=args[1], 
#                output_file=output_path, cell_value ="Q.value", data_label = "Module Pathways")
#print("Hello2")
#output_path = paste(args[3],"/OTU.pdf", sep="")

maaslin_heatmap(title = "Metadata vs. OTUs",  output_file='./output/OTU.pdf',
                maaslin_output='./output/MODULE/MODULE.txt', cell_value ="Q.value", data_label = "Pathways")

maaslin_heatmap(title = "Metadata vs. Metabolomic Modules",  output_file='./output/MODULE.pdf',
                maaslin_output='./output/MODULE/MODULE.txt', cell_value ="Q.value", data_label = "Pathways")







