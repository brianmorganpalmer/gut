
INPUT_TABLE=$1
INPUT_CONFIG=$2
OUTPUT_FILE=$3
OUTPUT_FOLDER=$(dirname "$3")

Rscript --vanilla -e "library(Maaslin); Maaslin('$INPUT_TABLE', '$OUTPUT_FOLDER', strInputConfig='$INPUT_CONFIG', dSignificanceLevel =.1)"

