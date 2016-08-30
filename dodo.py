from doitutils import dodict, check

# ---------------------------------------------------------------
# Requirements:
## HUMAnN2 >= 8.0
## HAllA >= 0.6.14
## R with maaslin, gamlss, and pheatmap packages
## Macqiime
# ---------------------------------------------------------------



# ---------------------------------------------------------------
# confirm humann2 version and macqiime
# ---------------------------------------------------------------

check("humann2 --version", "humann2", local=True)
check("halla --version", "halla", local=True)
#check("macqiime --version", "MacQIIME", local=True)

# ---------------------------------------------------------------
# alias for paths and files
# ---------------------------------------------------------------
alias = {
    "INPUT": "input",
    "OUTPUT": "output",
    "PICRUSt_RESULT":"ag_10k_fecal_kegg.biom",
    "OTU_BIOM":"ag_10k_fecal.biom", 
    "SAMPLE_IDS": "single_ids_10k.txt",
    "METADATA":"ag_10k_fecal.txt",
    "MyR": "/usr/bin/R"
}

# ---------------------------------------------------------------
# tasks: humann2 runs for getting metabolomic modules
# ---------------------------------------------------------------
'''
def task_load_macqiime():
    return dodict(["echo \"!!!Please load macqiime in your terminal before doit if the next task fails!!!\""],clean=True, alias=alias)

def task_split_kegg_biom():
    return dodict(["humann2_split_table --input", 
                   "d:{INPUT}/{PICRUSt_RESULT} --output T:{OUTPUT}/PICRUSt_OUTPUT"],clean=True, alias=alias)
     
def task_humann2_get_modules():
    return dodict(["sh utils/run_humann2.sh","--input", 
                    "D:{OUTPUT}/PICRUSt_OUTPUT",
                    "--output", "T:{OUTPUT}/PICRUSt_MODULE"], clean=True, alias=alias) 
 # 
def task_humann2_join_modules(): 
    return dodict(["humann2_join_tables --input D:{OUTPUT}/PICRUSt_MODULE --output",
                   "t:{OUTPUT}/humann2_pathabundance.tsv --file_name pathabundance"], alias=alias)  

def task_humann2_rename_modules():
    return dodict(["humann2_rename_table",
                   "--input d:{OUTPUT}/humann2_pathabundance.tsv",
                    "--names kegg-module --simplify",
                    "--output t:{OUTPUT}/humann2_pathabundance_names.tsv"], alias=alias)
    
# ---------------------------------------------------------------
# tasks: qiime runs to genrate and filter OTUs
# ---------------------------------------------------------------

def task_filter_otus_from_otu_table():
    return dodict(["filter_otus_from_otu_table.py -i d:{INPUT}/{OTU_BIOM} ",
                    "-s 5 -n 3 -o t:{OUTPUT}/OTU.biom"], alias=alias)
 
def task_summarize_taxa():
    return dodict(["summarize_taxa.py -i d:{OUTPUT}/OTU.biom -o T:{OUTPUT}/AG_taxa -L 2,3,4,5,6,7 "], clean=True, alias=alias) 

def task_merge_otu_tables():
    return dodict(["merge_otu_tables.py -i", 
                    "{OUTPUT}/AG_taxa/OTU_L2.biom,{OUTPUT}/AG_taxa/OTU_L3.biom,{OUTPUT}/AG_taxa/OTU_L4.biom,{OUTPUT}/AG_taxa/OTU_L5.biom,{OUTPUT}/AG_taxa/OTU_L6.biom", 
                    "-o t:{OUTPUT}/summed_AG.biom"], alias=alias) 

def task_convert_biom2tsv():
    return dodict(["biom convert -i d:{OUTPUT}/summed_AG.biom",
                   "-o t:{OUTPUT}/summed_AG.txt --table-type=\"OTU table\" --to-tsv"], alias=alias)

s# ---------------------------------------------------------------
# tasks: data cleaning and formatting for MaAsLin runs
# ---------------------------------------------------------------
def task_prepare_data_tables():
    return dodict(["Rscript --vanilla d:./utils/data_prep.R d:{INPUT}/{SAMPLE_IDS}",
                   "d:{OUTPUT}/summed_AG.txt d:{OUTPUT}/humann2_pathabundance_names.tsv",
                   "d:{INPUT}/{METADATA} t:{OUTPUT}"], alias=alias)


# ---------------------------------------------------------------
# tasks: association testing using MaAsLin 
# ---------------------------------------------------------------
'''
def task_test_association():
    return dodict(["{MyR} CMD BATCH --vanila d:utils/test_associations.R"], alias=alias)
    #return dodict(["{MyR} CMD BATCH  --vanilla q:./utils/test_associations.R d:{OUTPUT}/MODULE.tsv",
    #               "d:{OUTPUT}/MODULE d:{INPUT}/maaslin_config/masslin_config_module.txt"], alias=alias)
'''
def task_test_association_HAllA_OTU():
    return dodict(["halla -X d:{OUTPUT}/HAllA_Metadata.tsv -Y d:{OUTPUT}/HAllA_OTU.tsv",
                   " -o t:{OUTPUT}/HAllA_OUTPUT_OTU -q .05",
                   " --header"], alias=alias)
    
def task_test_association_HAllA_MODULE():
    return dodict(["halla -X d:{OUTPUT}/HAllA_Metadata.tsv -Y d:{OUTPUT}/HAllA_Module.tsv",
                    "-o t:{OUTPUT}/HAllA_OUTPUT_Module -q .05",
                   " --header"], alias=alias)
    

# ---------------------------------------------------------------
# tasks: Plot results
# ---------------------------------------------------------------
'''
def task_plot_association():
    return dodict(["{MyR} CMD BATCH --vanila d:utils/plot.R" ],alias=alias )
'''       
def task_plot_GraPhlAn():
    return dodict(["echo \"Plot Graphlan should be implemented here \" " ],alias=alias )
'''         
        
