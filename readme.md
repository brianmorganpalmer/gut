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
8. [QIIME](http://qiime.org)
9. [BIOM-Format](http://biom-format.org)
10. [h5py](www.h5py.org/)

## Installation ##

1. Download and decompress the american gut repository

    a. Download the american_gut repository: [american_gut.tar.gz](https://bitbucket.org/biobakery/american_gut/get/tip.tar.gz)

    b. Decompress the american_gut repository: ``$ tar zxvf american_gut.tar.gz``

2. Install the required software dependencies

    a. Run the script provided to automatically install dependencies: ``$ sh -x american_gut/install_requirements.sh``

    b. Alternatively, you can install the dependencies manually.

3. Add the HUMAnN1 KEGG pathways databases to the input folder 

    a. Download HUMAnN1: [humann-v0.99.tar.gz](https://bitbucket.org/biobakery/humann/downloads/humann-v0.99.tar.gz)

    b. Decompress the HUMAnN1 download: ``$ tar zxvf humann-v0.99.tar.gz``

    c. Copy the KEGG modules and pathways files to the american_gut input folder

        $ cp humann-v0.99/data/keggc biobakery-american_gut/input/kegg_dbs/
        $ cp humann-v0.99/data/modulec biobakery-american_gut/input/kegg_dbs/

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

1. Change directories into the american_gut folder: ``$ cd biobakery-american_gut``
2. Run doit to start the workflow: ``$ doit``

## Output ##

The current final outputs are HAllA, HUMAnN2, and MaAsLin output under output directory. The intermediate results are also under ``output`` directory.
