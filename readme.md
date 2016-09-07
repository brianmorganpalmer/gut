#American Gut Project Analysis #
This is a pipeline for American Gut Project Analysis. 


* [Requirements](#markdown-header-requirements)
* [Installation](#markdown-header-installation)
* [Input data](#markdown-header-input-data)
* [How to run](#markdown-header-how-to-run)
* [Output](#markdown-header-output)
 

## Requirements ##

1. [Python](https://www.python.org/)
2. [R](https://www.r-project.org) 
3. [DOIT](http://pydoit.org/install.html)
4. [HUMAnN2](http://huttenhower.sph.harvard.edu/humann2)
5. [HAllA](http://huttenhower.sph.harvard.edu/halla)
6. [MaAsLin](https://bitbucket.org/biobakery/maaslin)
7. pheatmap
8. [macqiime](http://www.wernerlab.org/software/macqiime/macqiime-installation) for Mac OS or [QIIME](http://qiime.org) for Linux OS
9. [BIOM-Format](http://biom-format.org)

After installing R and Python, run the following commands to install the other dependencies. First install pip if it was not included with your Python install.

```
$ pip install configparser==3.5.0b2
$ pip install doit==0.29.0
$ pip install numpy future matplotlib==1.4.3 mock nose h5py
$ pip install humann2
$ pip install halla
$ pip install qiime
$ pip install biom-format
$ R -e "install.packages(c('agricolae', 'gam', 'gamlss', 'gbm', 'glmnet', 'inlinedocs', 'logging', 'MASS', 'nlme', 'optparse', 'outliers', 'penalized', 'pscl', 'robustbase', 'pheatmap'), repos='http://cran.r-project.org')"
$ wget https://bitbucket.org/biobakery/maaslin/downloads/Maaslin_0.0.4.tar.gz
$ R CMD INSTALL Maaslin_0.0.4.tar.gz
```

## Installation ##

1. Install all the dependencies 
2. Download and decompress the american gut repository

    a. Download the american_gut repository: [american_gut.tar.gz](https://bitbucket.org/biobakery/american_gut/get/tip.tar.gz)

    b. Decompress the american_gut repository: ``$ tar zxvf american_gut.tar.gz``

3. Add the HUMAnN1 KEGG pathways databases to the input folder 

    a. Download HUMAnN1: [humann-v0.99.tar.gz](https://bitbucket.org/biobakery/humann/downloads/humann-v0.99.tar.gz)

    b. Decompress the HUMAnN1 download: ``$ tar zxvf humann-v0.99.tar.gz``

    c. Copy the KEGG modules and pathways files to the american_gut input folder

        $ cp humann-v0.99/data/keggc input/kegg_dbs/
        $ cp humann-v0.99/data/modulec input/kegg_dbs/

4. Place the four input files in the american_gut input folder and update the corresponding names in the alias section in the dodo.py file.

## Input data ##
Four main files should be added to the input directory (with their names 
provided in the alias section of the dodo file):

* PICRUSt_RESULT as a biom file
 
* OTU_BIOM as a biom file 

* SAMPLE_IDS as a text file
  
* METADATA as a text file

Two KEGG database files should also be added to the input directory:

* KEGG pathways database 

* KEGG modules database  

## How to run ##

1. Change directories into the american_gut folder: ``$ cd american_gut``
2. Run MacQIIME if on a Mac OS and QIIME is not in your system path (this step can be skipped for all other cases): `` $ macqiime``
3. Run doit to start the workflow: ``$ doit``

## Output ##

The current final outputs are HAllA, HUMAnN2, and MaAsLin output under output directory. The intermediate results are also under ``output`` directory.  