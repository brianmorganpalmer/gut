library(Maaslin)
library(gamlss)
library(grid)
library('pheatmap')

maaslin_heatmap(title ="Metabolomic Modules vs Metadata ", maaslin_output='../ouput/MODULE/MODULE.txt', data_label = "Module Pathways")
maaslin_heatmap(title ="OTUs vs Metadata ", maaslin_output='../ouput/OTU/OTU.txt', data_label = "OTUs")
graphics.off()





