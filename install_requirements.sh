
# This script will install the requirements for the american gut workflow.

# Install the latest devel version of future so that this will not overlap with configparser required by doit
pip install https://github.com/PythonCharmers/python-future/archive/v0.16.x.zip

# Install doit version for python2 (future versions are only python3)
pip install doit==0.29.0

# Install dependencies of required packages
pip install numpy future matplotlib==1.4.3 mock nose h5py

# Install required python packages
pip install humann2
pip install halla
pip install qiime
pip install biom-format
pip install h5py

# Install required R packages, first installing Maaslin dependencies and pheatmap
R -e "install.packages(c('agricolae', 'gam', 'gamlss', 'gbm', 'glmnet', 'inlinedocs', 'logging', 'MASS', 'nlme', 'optparse', 'outliers', 'penalized', 'pscl', 'robustbase', 'pheatmap', 'ggplot2', 'cowplot'), repos='http://cran.r-project.org')"
wget https://bitbucket.org/biobakery/maaslin/downloads/Maaslin_0.0.4.tar.gz
R CMD INSTALL Maaslin_0.0.4.tar.gz
rm Maaslin_0.0.4.tar.gz
