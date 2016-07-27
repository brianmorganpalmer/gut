
MODULE_DATBASE=/n/huttenhower_lab/tools/humann/data/modulec
PATHWAY_DATABASE=/n/huttenhower_lab/tools/humann/data/keggc
INPUTPATH="../output/PICRUSt_OUTPUT"


for file in $INPUT_PATH/*.tsv
do
	FILE_NAME=$(basename $file .tsv)
        if [ -f /n/home13/grahnavard/AG_data/PICRUSt_MODULE/${FILE_NAME}_pathcoverage.tsv ];
        then
                #stat /n/regal/huttenhower_lab/grahnavard/HMP1II/humann2_output/${FILE_NAME}/${FILE_NAME}_pathcoverage.tsv
                #echo it exist!
                echo $FILE_NAME
                continue

        fi 
#PAthways
#humann2 --input $file --output /n/home13/grahnavard/AG_data/PICRUSt_OUTPUT2 --pathways-database  $PATHWAY_DATABASE

#Modules
humann2 --input $file --output /n/home13/grahnavard/AG_data/PICRUSt_MODULE --pathways-database $MODULE_DATBASE
done
