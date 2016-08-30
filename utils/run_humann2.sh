
MODULE_DATBASE=./input/humann-0.99/data/modulec
PATHWAY_DATABASE=./input/humann-0.99/data/keggc
INPUTPATH="output/PICRUSt_OUTPUT"


for file in $INPUTPATH/*.biom
do
	FILE_NAME=$(basename $file .biom)
        if [ -f output/PICRUSt_MODULE/${FILE_NAME}_pathcoverage.tsv ];
        then
                #stat /n/regal/huttenhower_lab/grahnavard/HMP1II/humann2_output/${FILE_NAME}/${FILE_NAME}_pathcoverage.tsv
                #echo it exist!
                echo $FILE_NAME
                continue

        fi 
#PAthways
#humann2 --input $file --output /n/home13/grahnavard/AG_data/PICRUSt_OUTPUT2 --pathways-database  $PATHWAY_DATABASE

#Modules
humann2 --input $file --output output/PICRUSt_MODULE --pathways-database $MODULE_DATBASE
done
