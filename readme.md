#American Gut Project Analysis #
This is a pipeline for American Gut Project Analysis. 


* [Requirements](#markdown-header-requirements)
* [Input data](#markdown-header-input-data)
* [How to run](#markdown-header-how-to-run)
* [Output](#markdown-header-output)
 

## Requirements ##
* macqiime
* R with maaslin, gamlss, and pheatmap packages
* MaAsLin

## Input data ##
Four main files that should be located in the input directory and and their names 
should be set in alias section of the dodo file are:

* PICRUSt_RESULT as a biom file
 
* OTU_BIOM as a biom file 

* SAMPLE_IDS as a text file
  
* METADATA as a text file  

## How to run ##
``$macqiime``

``$doit``

## Output ##
The intermediate results and final outputs will be written in the output directory.