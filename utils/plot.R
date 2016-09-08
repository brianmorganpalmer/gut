#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

source('./utils/r_utils.R')

if (length(args)<4){
  print("Please provide two input files and two output files.")
}

maaslin_heatmap(title = "Metadata vs. OTUs",  output_file=args[2],
                maaslin_output=args[1], cell_value ="Q.value", data_label = "OTUs")

maaslin_heatmap(title = "Metadata vs. Metabolomic Modules",  output_file=args[4],
                maaslin_output=args[3], cell_value ="Q.value", data_label = "Pathways")
                
             
