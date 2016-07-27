from doitutils import dodict, check

# ---------------------------------------------------------------
# confirm humann2 version and macqiime
# ---------------------------------------------------------------

check("humann2 --version", "humann2 v0.8.0")
check("macqiime --version", "MacQIIME", local=True)

# ---------------------------------------------------------------
# alias for paths and files
# ---------------------------------------------------------------
alias = {
    "INPUT": "input",
    "OUTPUT": "output",
    "PICRUSt_RESULT":"ag_10k_fecal_kegg.biom",
    "OTU_BIOM":"AGP_100nt_even10k_fecal.biom", 
    "METADATA": "single_ids_10k.txt"
}

# ---------------------------------------------------------------
# tasks: humann2 runs for getting modules
# ---------------------------------------------------------------

def task_split_kegg_biom():
    return dodict(["humann2_split_table --input", 
                    "d:{INPUT}/{PICRUSt_RESULT} --output t:{OUTPUT}/PICRUSt_OUTPUT"], alias=alias)
#     
def task_humann2_get_modules():
    return dodict(["sh d:run_humann2.sh","--input", 
                    "d:{OUTPUT}/PICRUSt_OUTPUT", "--output", "t:{OUTPUT}/PICRUSt_MODULE"], alias=alias) 
    
def task_humann2_join_modules(): 
    return dodict(["humann2_join_tables --input d:{OUTPUT}/PICRUSt_MODULE -output",
                   "t:{OUTPUT}/humann2_pathcoverage.tsv --file_name pathcoverage"], alias=alias)  

def task_humann2_rename_modules():
    return dodict(["humann2_rename_table",
                   "--input d:{OUTPUT}/humann2_pathabundance.tsv",
                    "--names kegg-module --simplify",
                    "--output t:{OUTPUT}/humann2_pathabundance_names.tsv"], alias=alias)
    

# ---------------------------------------------------------------
# tasks: qiime runs to genrate and filter OTUs
# ---------------------------------------------------------------

def filter_otus_from_otu_table():
    return dodict(["filter_otus_from_otu_table.py -i d:{INPUT}/{OTU_BIOM}",
                    "-s 5 -n 3 -o t:{OUTPUT}/OTU.biom"], alias=alias)  
    
def summarize_taxa():
    return dodict(["summarize_taxa.py -i d:OTU.biom -o t:{OUTPUT}/AG_tax -L 2,3,4,5,6,7"], alias=alias) 

def merge_otu_tables():
    return dodict(["merge_otu_tables.py -i", 
                    "{OUTPUT}/AG_tax/OTU_L2.biom,{OUTPUT}/AG_tax/OTU_L3.biom,{OUTPUT}/AG_tax/OTU_L4.biom\
                    ,{OUTPUT}/AG_tax/OTU_L5.biom,{OUTPUT}/AG_tax/OTU_L6.biom -o {OUTPUT}/summed_AG.biom"], alias=alias) 
    
def convert_biom2tsv():
    return dodict(["biom convert -i d:{OUTPUT}/summed_AG.biom",
                   "-o t:{OUTPUT}/summed_AG.txt --table-type=\"OTU table\" --to-tsv"], alias=alias)
    
# ---------------------------------------------------------------
# tasks: data cleaning and formatting for MaAsLin runs
# ---------------------------------------------------------------

def prepare_metadata_OTU_and_metadata_Module_tables():
    return dodict(["Rscript --vanilla ../utils/data_prep.R METADATA",
                   "d:{OUTPUT}/AG_tax/summed_AG.txt d:{OUTPUT}/humann2_pathabundance_names.tsv t:{OUTPUT}"], alias=alias)

# ---------------------------------------------------------------
# tasks: association testing using MaAsLin 
# ---------------------------------------------------------------

def test_association():
    return dodict(["Rscript --vanilla ../utils/test_association.R"])

# ---------------------------------------------------------------
# tasks: Plot results
# ---------------------------------------------------------------

def plot_association():
    return dodict(["Rscript --vanilla ../utils/plot.R"])
        
        
