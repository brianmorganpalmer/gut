
MODULE_DATBASE=./input/kegg_dbs/modulec
PATHWAY_DATABASE=./input/kegg_dbs/keggc
INPUTPATH="output/PICRUSt_OUTPUT"


for file in $INPUTPATH/*.biom
do
	FILE_NAME=$(basename $file .biom)
        if [ -f output/PICRUSt_MODULE/${FILE_NAME}_pathcoverage.tsv ];
        then
                echo $FILE_NAME
                continue

        fi 

#Modules
humann2 --input $file --output output/PICRUSt_MODULE --pathways-database $MODULE_DATBASE
done
