from doitutils import dodict

#check for main tool installations
check = {"humman2 --version": "humann2 v0.8.0",
        "macqiime --version": "MacQIIME 1.9.1-20150604"}

alias = {
    "INPUT": "~/Documents/American_Gut_Info/input",
    "OUTPUT": "~/Documents/American_Gut_Info/input",
    "PICRUSt_RESULT":"ag_10k_fecal_kegg.biom",
    "OTU_BIOM":"AGP_100nt_even10k_fecal.biom", 
    "METADATA": "single_ids_10k.txt"
}
def load_qiime():
    return dodict(["macqiime"])

def task_split_kegg_biom():
    return dodict(["humann2_split_table --input", 
                    "d:~/Documents/American_Gut_Info/input/ag_10k_fecal_kegg.biom --output t:OUTPUT/PICRUSt_OUTPUT"], alias=alias)
# INPUT/PICRUSt_RESULT    
def task_humann2_get_modules():
    return dodict(["sh run_humann2.sh","--input", 
                    "d:OUTPUT/PICRUSt_OUTPUT", "--output", "t:OUTPUT/PICRUSt_MODULE"],alias=alias) 
    
def task_humann2_join_modules(): 
    return dodict(["humann2_join_tables --input d:OUTPUT/PICRUSt_MODULE -output",
                   "t:OUTPUT/humann2_pathcoverage.tsv --file_name pathcoverage"], alias=alias)  

def task_humann2_rename_modules():
    return dodict(["humann2_rename_table",
                   "--input d:OUTPUT/humann2_pathabundance.tsv",
                    "--names kegg-module --simplify",
                    "--output t:OUTPUT/humann2_pathabundance_names.tsv"], alias=alias)
    
# Generate and Filter OTUs 
def filter_otus_from_otu_table():
    return dodict(["filter_otus_from_otu_table.py -i INPUT/OTU_BIOM",
                    "-s 5 -n 3 -o OUTPUT/OTU.biom"], alias=alias)  
    
def summarize_taxa():
    return dodict(["summarize_taxa.py -i OTU.biom -o OUTPUT/AG_tax -L 2,3,4,5,6,7"], alias=alias) 

def merge_otu_tables():
    return dodict(["merge_otu_tables.py -i OTU_L2.biom",
                   "OTU_L3.biom,OTU_L4.biom,OTU_L5.biom,OTU_L6.biom -o OUTPUT/summed_AG.biom"], alias=alias) 
    
def convert_biom2tsv():
    return dodict(["biom convert -i OUTPUT/summed_AG.biom",
                   "-o OUTPUT/summed_AG.txt --table-type=\"OTU table\" --to-tsv"], alias=alias)
    
def prepare_metadata_OTU_and_metadata_Module_tables():
    return dodict(["Rscript --vanilla ../utils/data_prep.R METADATA",
                   "d:AG_tax/summed_AG.txt d:input/humann2_pathabundance_names.tsv t:OUTPUT"], alias=alias)

def test_association():
    return dodict(["Rscript --vanilla ../utils/test_association.R"])

def plot_association():
    return dodict(["Rscript --vanilla ../utils/plot.R"])
        
        
