#American Gut Project Analysis #
This is a pipeline for American Gut Project Analysis. 


* [Requirements](#markdown-header-requirements)
* [Input data](#markdown-header-input-data)
* [How to run](#markdown-header-how-to-run)
* [Output](#markdown-header-output)
 

## Requirements ##
* [HUMAnN2](http://huttenhower.sph.harvard.edu/humann2)
* R with maaslin, gamlss, and pheatmap packages
* [MaAsLin](https://bitbucket.org/biobakery/maaslin)
* [macqiime](http://www.wernerlab.org/software/macqiime/macqiime-installation)
## Input data ##
Four main files that should be located in the input directory and and their names 
should be set in alias section of the dodo file are:

* PICRUSt_RESULT as a biom file
 
* OTU_BIOM as a biom file 

* SAMPLE_IDS as a text file
  
* METADATA as a text file  

## How to run ##
Download the american_gut repository from [Download](https://bitbucket.org/biobakery/american_gut/get/e650c8340d50.zip)

``$cd biobakery-american_gut_XXX (replace XXX by the newest version)``

``$macqiime``

``$doit``

## Output ##
The intermediate results and final outputs will be written in the output directory.