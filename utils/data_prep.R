#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# This script gets the ids of samples , OTU table and Module abundance table and
# genertes two clean tables of OTU and Modules as input for MaAsLin

#library(Maaslin)
#library(gamlss)
#example(Maaslin)

if (length(args)<3) {
  stop("Three files must must be supplied (ids table, taxa table, and modules abundance table).\n", call.=FALSE)
}
if (length(args)<4) {
  print('Warning! Outputs will be written in the current directory')
  args[4] = getwd()
}
if (length(args) == 4) {
  print('Outputs will be written into provided output')
}

#ids <- read.table( '/Users/rah/Documents/American_Gut_Info/ag-precomputed-rounds-1-21/fecal/single_ids_10k.txt', header = TRUE, row.names = 1,sep = "\t", fill = FALSE, comment.char = "" , check.names = FALSE)
ids <- read.table( args[1], header = TRUE, row.names = 1,sep = "\t", fill = FALSE, comment.char = "" , check.names = FALSE)
ids <- t(ids)

#OTU <- read.table( '/Users/rah/Documents/American_Gut_Info/AG_tax/summed_AG.txt', header = TRUE, row.names = 1, sep = "\t", fill = FALSE, comment.char = "" , check.names = FALSE)
OTU <- read.table( args[2], header = TRUE, row.names = 1, sep = "\t", fill = FALSE, comment.char = "" , check.names = FALSE)
print ('OTU table dimension:')
dim(OTU)

#MODULE <- read.table( '/Users/rah/Documents/American_Gut_Info/New_data/ag_module_humann2_pathabundance.tsv', header = TRUE, row.names = 1, sep = "\t", fill = FALSE, comment.char = "" , check.names = FALSE)
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

metadata <- read.table( '/Users/rah/Documents/American_Gut_Info/ag-precomputed-rounds-1-21/fecal/100nt/all_participants/all_samples/10k/ag_10k_fecal.txt', header = TRUE, row.names = 1, sep = "\t", fill = FALSE, quote="", comment.char = "" , check.names = FALSE)

#metadata <- metadata[!(as.numeric(metadata[,'AGE_CORRECTED']) < 3 && as.numeric(metadata[,'WEIGHT_KG']) > 18 && as.numeric(metadata[,'HEIGHT_CM'] > 91)) ] #   m[m[, "three")] 

metadata <- t(metadata)
print ("Metadata table dimension:")
dim(metadata)

OTU <- OTU[, colnames(OTU)%in% colnames(ids)]
OTU <- OTU[, order(colnames(OTU))]

metadata <- metadata[, colnames(metadata)%in% colnames(OTU)]

metadata <- metadata[c('AGE_CORRECTED', 'ALCOHOL_CONSUMPTION', 'ANTIBIOTIC_HISTORY', 'BMI' ,'CSECTION','COUNTRY', 
                       'DIABETES', 'IBD', 'LACTOSE', 'RACE', 'SEX', 'TYPES_OF_PLANTS', 
                       'SLEEP_DURATION','EXERCISE_FREQUENCY'), ]

metadata <- metadata[, order(colnames(metadata))]
metadata.OTU <- rbind(as.matrix(metadata),as.matrix(OTU))
metadata.Module <- rbind(as.matrix(metadata),as.matrix(MODULE))
d <- dim(metadata.OTU)
for (i in 1:d[1])
  for (j in 1:d[2]){
    if ( metadata.OTU[i,j] == "Unknown" || metadata.OTU[i,j] == "NA"){
      metadata.OTU[i,j] <- ""
    }
  }
for (i in 1:d[2]){
  if (metadata.OTU['BMI',i] != "")
    if (as.numeric(metadata.OTU['BMI',i]) < 10.0 || as.numeric(metadata.OTU['BMI', i]) > 50.0){
      metadata.OTU['BMI', i] <- ""
  }
}
rare_country <- c("Belgium",  "Brazil","China", "Czech Republic","Denmark", "Finland", "France", "Germany",
                  "Ireland", "Isle of Man", "Italy", "Japan", "Jersey", "Netherlands", "New Zealand",	"Norway",
                  "Poland", "Spain", "Sweden",	"Switzerland",	"Thailand", "United Arab Emirates")
for (i in 1:d[2]){
  if (metadata.OTU['COUNTRY',i] != "")
    if (is.element(metadata.OTU['COUNTRY',i],rare_country)){
      metadata.OTU['COUNTRY', i] <- "Other"
    }
}
for (i in 1:d[2]){
  if (metadata.OTU['SEX',i] == "other")
      metadata.OTU['SEX', i] <- ""
}
metadata.OTU['BMI',] <- as.double(metadata.OTU['BMI',])
#as.double(metadata.OTU['BMI',])
#metadata.OTU['BMI',]
#dim(metadata.OTU)

d <- dim(metadata.Module)
for (i in 1:d[1])
  for (j in 1:d[2]){
    if ( metadata.Module[i,j] == "Unknown" || metadata.Module[i,j] == "NA"){
      metadata.Module[i,j] <- ""
    }
  }
for (i in 1:d[2]){
  if (metadata.Module['BMI',i] != "")
    if (as.numeric(metadata.Module['BMI',i]) < 10.0 || as.numeric(metadata.Module['BMI', i]) > 50.0){
      metadata.Module['BMI', i] <- ""
    }
}
for (i in 1:d[2]){
  if (metadata.Module['SEX',i] == "other")
    metadata.Module['SEX', i] <- ""
}

for (i in 1:d[2]){
  if (metadata.OTU['COUNTRY',i] != "")
    if (is.element(metadata.OTU['COUNTRY',i],rare_country)){
      metadata.OTU['COUNTRY', i] <- "Other"
    }
}
for (i in 1:d[2]){
  if (metadata.Module['COUNTRY',i] != "")
    if (is.element(metadata.Module['COUNTRY',i],rare_country)){
      metadata.Module['COUNTRY', i] <- "Other"
    }
}
for (i in 1:d[2]){
  if (metadata.OTU['DIABETES',i] != "")
    if (metadata.OTU['DIABETES',i] == "Diagnosed by an alternative medicine practitione"
        || metadata.OTU['DIABETES',i] == "Self-diagnosed"
        || metadata.OTU['DIABETES',i] == "Diagnosed by a medical professional (doctor, physician assistant)"
        || metadata.OTU['DIABETES',i] == "Diagnosed by an alternative medicine practitioner"){
      metadata.OTU['DIABETES', i] <- "Yes"
    }
  else if (metadata.OTU['DIABETES',i] == "I do not have this condition"){
    metadata.OTU['DIABETES', i] <- "No"
  }
}


for (i in 1:d[2]){
  if (metadata.Module['DIABETES',i] != "")
    if (metadata.Module['DIABETES',i] == "Diagnosed by an alternative medicine practitione"
        || metadata.Module['DIABETES',i] == "Self-diagnosed"
        || metadata.Module['DIABETES',i] == "Diagnosed by a medical professional (doctor, physician assistant)"
        || metadata.Module['DIABETES',i] == "Diagnosed by an alternative medicine practitioner"){
      metadata.Module['DIABETES', i] <- "Yes"
    }
  else if (metadata.Module['DIABETES',i] == "I do not have this condition"){
    metadata.Module['DIABETES', i] <- "No"
  }
}
# IBD
for (i in 1:d[2]){
  if (metadata.OTU['IBD',i] != "")
    if (metadata.OTU['IBD',i] == "Diagnosed by an alternative medicine practitione"
        || metadata.OTU['IBD',i] == "Self-diagnosed"
        || metadata.OTU['IBD',i] == "Diagnosed by a medical professional (doctor, physician assistant)"
        || metadata.OTU['IBD',i] == "Diagnosed by an alternative medicine practitioner"){
      metadata.OTU['IBD', i] <- "Yes"
    }
  else if (metadata.OTU['IBD',i] == "I do not have this condition"){
    metadata.OTU['IBD', i] <- "No"
  }
}


for (i in 1:d[2]){
  if (metadata.Module['IBD',i] != "")
    if (metadata.Module['IBD',i] == "Diagnosed by an alternative medicine practitione"
        || metadata.Module['IBD',i] == "Self-diagnosed"
        || metadata.Module['IBD',i] == "Diagnosed by a medical professional (doctor, physician assistant)"
        || metadata.Module['IBD',i] == "Diagnosed by an alternative medicine practitioner"){
      metadata.Module['IBD', i] <- "Yes"
    }
  else if (metadata.Module['IBD',i] == "I do not have this condition"){
    metadata.Module['IBD', i] <- "No"
  }
}
metadata.Module['BMI',] <- as.double(metadata.Module['BMI',])

#'/Users/rah/Documents/American_Gut_Info/New_data
write.table(metadata.OTU, paste(args[4],"/OTU.pcl", sep=""), sep = "\t", eol = "\n", col.names = NA, row.names = T)
write.table(metadata.Module, paste(args[4],"/MODULE.pcl", sep=""), sep = "\t", eol = "\n", col.names = NA, row.names = T)


#write.table(t(metadata.Module), '/Users/rah/Documents/American_Gut_Info/New_data/MODULE_HUMAnN2.tsv', sep = "\t", eol = "\n", col.names = NA, row.names = T)

#Maaslin('/Users/rah/Documents/American_Gut_Info/New_data/OTU.tsv','/Users/rah/Documents/American_Gut_Info/Version4/OTU_ZI',
#        strInputConfig='/Users/rah/Documents/American_Gut_Info/scripts/input.read.config.otu')#, fZeroInflated = TRUE)

