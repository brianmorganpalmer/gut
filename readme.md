#American Gut Project Analysis #
This is a pipeline for American Gut Project Analysis. 


* [Requirements](#markdown-header-requirements)
* [Input data](#markdown-header-input-data)
* [How to run](#markdown-header-how-to-run)
* [Output](#markdown-header-output)
 

## Requirements ##
* [DOIT](http://pydoit.org/install.html)
* [HUMAnN2](http://huttenhower.sph.harvard.edu/humann2)
* [HAllA](http://huttenhower.sph.harvard.edu/halla)
* R with maaslin, gamlss, and pheatmap packages
* [MaAsLin](https://bitbucket.org/biobakery/maaslin)
* [macqiime](http://www.wernerlab.org/software/macqiime/macqiime-installation) for Mac OS or [QIIME](http://qiime.org) for Linux OS

## Input data ##
Four main files that should be located in the input directory and and their names 
should be set in alias section of the dodo file are:

* PICRUSt_RESULT as a biom file
 
* OTU_BIOM as a biom file 

* SAMPLE_IDS as a text file
  
* METADATA as a text file

* KEGG pathways database 

* KEGG modules database  

## How to run ##

Install all the dependencies 

Download the american_gut repository from [Download](https://bitbucket.org/biobakery/american_gut/downloads)

Decompress the american_gut repository

Download HUMAnN1 from [Download](https://bitbucket.org/biobakery/humann/downloads/humann-v0.99.tar.gz) and from ``./input/humann-0.99/data/`` copy KEGG pathways database ``keggc`` and KEGG modules database ``modulec`` under the repository into ``input/kegg_dbs/``. In a case, there is a new version of KEGG available then those file could be replaced by the new version.  

Place the four input file and update the corresponding names in the alias section in the dodo.py file:
``
alias = {
    "PICRUSt_RESULT":"ag_10k_fecal_kegg.biom",
    "OTU_BIOM":"ag_10k_fecal.biom", 
    "SAMPLE_IDS": "single_ids_10k.txt",
    "METADATA":"ag_10k_fecal.txt",
}
``

``$cd biobakery-american_gut_XXX (replace XXX by the newest version)``

If QIIME is configured under your machine path or if you use Linux OS the next step, running macqiime, could be skipped.

``$macqiime``

``$doit``

## Output ##

The current final outputs are HAllA, HUMAnN2, and MaAsLin output under output directory. The intermediate results are also under ``output`` dirctory.  
The intermediate results and final outputs will be written in the output directory.