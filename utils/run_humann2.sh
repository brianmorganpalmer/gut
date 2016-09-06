
MODULE_DATBASE=./input/kegg_dbs/modulec
PATHWAY_DATABASE=./input/kegg_dbs/keggc

INPUT=$1
OUTPUT=$2

for file in $INPUT/*.biom
do
	FILE_NAME=$(basename $file .biom)
        if [ -f $OUTPUT/${FILE_NAME}_pathcoverage.tsv ];
        then
                echo $FILE_NAME
                continue

        fi 

#Modules
humann2 --input $file --output $OUTPUT --pathways-database $MODULE_DATBASE
done
