#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
args[1]= './input/single_ids_10k.txt'
args[2] = './output/summed_AG.txt'
args[3] = './output/humann2_pathabundance_names.tsv'
args[4] = './input/ag_10k_fecal.txt'
args[5] = './output'
# This script gets the ids of samples , OTU table and Module abundance table and
# genertes two clean tables of OTU and Modules as input for MaAsLin


if (length(args)<3) {
  stop("Three files must must be supplied (ids table, taxa table, and modules abundance table).\n", call.=FALSE)
}
if (length(args)<5) {
  print('Warning! Outputs will be written in the current directory')
  args[4] = getwd()
}
if (length(args) == 5) {
  print('Outputs will be written into provided output')
}
ids <- read.table( args[1], header = TRUE, row.names = 1,sep = "\t", fill = FALSE, comment.char = "" , check.names = FALSE)
ids <- t(ids)

OTU <- read.table( args[2], header = TRUE, row.names = 1, sep = "\t", fill = FALSE, comment.char = "" , check.names = FALSE, skip=1)
print ('OTU table dimension:')
dim(OTU)

MODULE <- read.table( args[3], header = TRUE, row.names = 1, sep = "\t", fill = FALSE, comment.char = "" , check.names = FALSE)
print ("Module table dimension:")
dim(MODULE)

# colnames(MODULE) <- gsub("-hit-keg-mpm-cop-nul-nve-nve", "", colnames(MODULE)) 04b-hit-keg-mpm-cop-nul-nve-nve.txt
colnames(MODULE) <- gsub("_Abundance", "", colnames(MODULE))
M_d <- dim(MODULE)
MODULE <- MODULE[18:M_d[1],]
MODULE <- MODULE[, colnames(MODULE)%in% colnames(ids)]
MODULE <- MODULE[, order(colnames(MODULE))]
M_d <- dim(MODULE)
ids <- ids[, colnames(ids)%in% colnames(MODULE)]
#American_Gut_Info/ag-precomputed-rounds-1-21/fecal/100nt/all_participants/all_samples/10k/ag_10k_fecal.txt
metadata <- read.table(args[4] , header = TRUE, row.names = 1, sep = "\t", fill = FALSE, quote="", comment.char = "" , check.names = FALSE)

#metadata <- metadata[!(as.numeric(metadata[,'AGE_CORRECTED']) < 3 && as.numeric(metadata[,'WEIGHT_KG']) > 18 && as.numeric(metadata[,'HEIGHT_CM'] > 91)) ] #   m[m[, "three")] 

metadata <- t(metadata)
print ("Metadata table dimension:")
dim(metadata)

OTU <- OTU[, colnames(OTU)%in% colnames(ids)]
OTU <- OTU[, order(colnames(OTU))]

metadata <- metadata[, colnames(metadata)%in% colnames(OTU)]


halla_metadata <- metadata[c('AGE_CORRECTED', 'ALCOHOL_CONSUMPTION', 'ANTIBIOTIC_HISTORY', 'BMI' ,'CSECTION','COUNTRY', 
                       'DIABETES', 'IBD', 'LACTOSE', 'RACE', 'SEX', 'TYPES_OF_PLANTS', 
                       'SLEEP_DURATION','EXERCISE_FREQUENCY', 'VIOSCREEN_FIBER'), ]

metadata <- metadata[c('AGE_CORRECTED', 'ALCOHOL_CONSUMPTION', 'ANTIBIOTIC_HISTORY', 'BMI' ,'CSECTION','COUNTRY', 
                       'DIABETES', 'IBD', 'LACTOSE', 'RACE', 'SEX', 'TYPES_OF_PLANTS', 
                       'SLEEP_DURATION','EXERCISE_FREQUENCY', 'VIOSCREEN_FIBER'), ] #'VIOSCREEN_FIBER',

## MODULEs
x <- rownames(MODULE)
x <- gsub(": ", "_", x)
x <- gsub("[:;:]", "_", x)
x <- gsub("[:.:]", "_", x)
x <- gsub("__", "_", x)
rownames(MODULE) <- x
y <- colnames(MODULE)
y <- gsub("[:.:]", "_", y)
colnames(MODULE) <- y

## OTUs
x <- rownames(OTU)
x <- gsub(": ", "_", x)
x <- gsub("[:.:]", "_", x)
x <- gsub("[:;:]", "_", x)
x <- gsub("__", "_", x)
rownames(OTU) <- x
y <- colnames(OTU)
y <- gsub("[:.:]", "_", y)
colnames(OTU) <- y

## metadata
x <- rownames(metadata)
x <- gsub(": ", "_", x)
x <- gsub("[:.:]", "_", x)
x <- gsub("[:;:]", "_", x)
x <- gsub("__", "_", x)
rownames(metadata) <- x
rownames(halla_metadata) <- x
y <- colnames(metadata)
y <- gsub("[:.:]", "_", y)
colnames(metadata) <- y

metadata <- as.matrix(metadata)
metadata['BMI',] <- as.double(metadata['BMI',])
d <- dim(metadata)
for (i in 1:d[1])
  for (j in 1:d[2]){
    #print(metadata[i,j])
    if ( metadata[i,j] == "Unknown" || is.na(metadata[i,j])){
      metadata[i,j] <- ""
    }
  }
for (i in 1:d[2]){
  if (metadata['BMI',i] != "")
    if (as.numeric(metadata['BMI',i]) < 10.0 || as.numeric(metadata['BMI', i]) > 50.0){
      metadata['BMI', i] <- ""
  }
}
rare_country <- c("Belgium",  "Brazil","China", "Czech Republic","Denmark", "Finland", "France", "Germany",
                  "Ireland", "Isle of Man", "Italy", "Japan", "Jersey", "Netherlands", "New Zealand",	"Norway",
                  "Poland", "Spain", "Sweden",	"Switzerland",	"Thailand", "United Arab Emirates")
for (i in 1:d[2]){
  if (metadata['COUNTRY',i] != "")
    if (is.element(metadata['COUNTRY',i],rare_country)){
      metadata['COUNTRY', i] <- "Other"
    }
}
for (i in 1:d[2]){
  if (metadata['SEX',i] == "other")
      metadata['SEX', i] <- ""
}

#Diabets
for (i in 1:d[2]){
  if (metadata['DIABETES',i] != "")
    if (metadata['DIABETES',i] == "Diagnosed by an alternative medicine practitione"
        || metadata['DIABETES',i] == "Self-diagnosed"
        || metadata['DIABETES',i] == "Diagnosed by a medical professional (doctor, physician assistant)"
        || metadata['DIABETES',i] == "Diagnosed by an alternative medicine practitioner"){
      metadata['DIABETES', i] <- "Yes"
    }
  else if (metadata['DIABETES',i] == "I do not have this condition"){
    metadata['DIABETES', i] <- "No"
  }
}


# IBD
for (i in 1:d[2]){
  if (metadata['IBD',i] != "")
    if (metadata['IBD',i] == "Diagnosed by an alternative medicine practitione"
        || metadata['IBD',i] == "Self-diagnosed"
        || metadata['IBD',i] == "Diagnosed by a medical professional (doctor, physician assistant)"
        || metadata['IBD',i] == "Diagnosed by an alternative medicine practitioner"){
      metadata['IBD', i] <- "Yes"
    }
  else if (metadata['IBD',i] == "I do not have this condition"){
    metadata['IBD', i] <- "No"
  }
}

# Creat a dirctory for HAllA input files
dir.create(file.path(args[5], "HAllA_INPUT"), showWarnings = FALSE)

write.table(data.frame("SAMPLE_ID"=rownames(metadata),metadata), row.names=FALSE, paste(args[5],"/HAllA_INPUT/HAllA_Metadata.tsv", sep=""), sep = "\t", eol = "\n",quote=F)
write.table(data.frame("SAMPLE_ID"=rownames(MODULE),MODULE), row.names=FALSE, paste(args[5],"/HAllA_INPUT/HAllA_Module.tsv", sep=""), sep = "\t", eol = "\n",quote=F)
write.table(data.frame("SAMPLE_ID"=rownames(OTU),OTU), row.names=FALSE, paste(args[5],"/HAllA_INPUT/HAllA_OTU.tsv", sep=""), sep = "\t", eol = "\n",quote=F)


metadata <- metadata[, order(colnames(metadata))]
metadata.OTU <- rbind(as.matrix(metadata),as.matrix(OTU))
metadata.Module <- rbind(as.matrix(metadata),as.matrix(MODULE))

# Creat a dirctory for MaAsLin input files
dir.create(file.path(args[5], "MaAsLin_INPUT"), showWarnings = FALSE)
write.table(data.frame("SAMPLE_ID"=rownames(t(metadata.Module)),t(metadata.Module)), row.names=FALSE, paste(args[5],"/MaAsLin_INPUT/MODULE.tsv", sep=""), sep = "\t", eol = "\n",quote=F)
write.table(data.frame("SAMPLE_ID"=rownames(t(metadata.OTU)),t(metadata.OTU)), row.names=FALSE, paste(args[5],"/MaAsLin_INPUT/OTU.tsv", sep=""), sep = "\t", eol = "\n",quote=F)
            #sep = "\t", eol = "\n",quote=F, col.names = NA, row.names = T)


