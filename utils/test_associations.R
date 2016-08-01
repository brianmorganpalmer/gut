#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(Maaslin)
library(gamlss)
#example(Maaslin)

if (length(args)<3){
  print("Please provide table input and config file, and a name for output directory!")
}

#Maaslin(args[1], args[3], args[2] strInputConfig='', dSignificanceLevel =.1)#, fZeroInflated = TRUE
Maaslin('/Users/rah/Documents/Hutlab/american_gut/output/MODULE.tsv', '/Users/rah/Documents/Hutlab/american_gut/output/MODULE',
        strInputConfig='/Users/rah/Documents/Hutlab/american_gut/input/maaslin_config/maaslin_config_module.txt', dSignificanceLevel =.1)#, fZeroInflated = TRUE
Maaslin('/Users/rah/Documents/Hutlab/american_gut/output/OTU.tsv', '/Users/rah/Documents/Hutlab/american_gut/output/OTU',
        strInputConfig='/Users/rah/Documents/Hutlab/american_gut/input/maaslin_config/maaslin_config_otu.txt', dSignificanceLevel =.1)#, fZeroInflated = TRUE


for(i in 1: length(dev.list()))
  dev.off()
