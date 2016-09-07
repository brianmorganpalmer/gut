#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(Maaslin)

if (length(args)<3){
  print("Please provide table input, config file, and a name for the output directory!")
}

Maaslin(args[1], args[3], strInputConfig=args[2], dSignificanceLevel =.1)#, fZeroInflated = TRUE

for(i in 1: length(dev.list()))
  try(dev.off(), silent=TRUE)
