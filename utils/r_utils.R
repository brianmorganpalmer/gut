# -----------------------------------------------------------------------------
#  MaAsLin  Output HEATMAP
pcl.sub <- function(x){
  #return(x)
  x <- strsplit(x, "_", fixed= TRUE)
  l <- length(x[[1]])
  x <- x[[1]][nchar(x[[1]]) > 2 ]
  l <- length(x)
  if (nchar(x[l-1]) < 5){
    x <- paste(paste(x[l-2], x[l-1]), x[l])
  }else{x <- paste(x[l-1], x[l])}
  
  #print(x)
  x <- gsub("__", "_", x)
  x <- gsub("__", "_", x)
  x <- gsub("_", " ", x)
  #x <- paste(paste(x[[1]][l-2][1], x[[1]][l-1][1]), x[[1]][l][1])
  #x <- gsub("__", "_", x)
  #x <- gsub("__", "_", x)
  #x <- gsub(" ", "", x)
  #if (x == 'g1_68')
  #  x <- 'Tissierellaceae_g_1_68'
  return(x)
}
convert_maaslin_output2matrix <- function(df){
  metadata <- df$Variable
  #print (df$Variable)
  all_metadata <-   c ("Subject_diet",
                       "Breast_feeding",
                       "Temperature",
                       "Introitus_pH",
                       "Posterior_fornix_pH",
                       "Gender",
                       "Age",
                       "Ethnicity",
                       "Systolic_blood_pressure",
                       "Diastolic_blood_pressure",
                       "Pulse",
                       "Subjects_having_given_birth",
                       "BMI",
                       "VISNO",
                       "Study_day_processed",
                       "Sequencing_center",  
                       "Clinical_center",  
                       "Number_of_quality_bases",
                       "Percent_of_Human_Reads",
                       "WMSPhase"
  )
  needed_metadata <-c ("Subject_diet",
                       "Breast_feeding",
                       "Subjects_having_given_birth",
                       "Gender",
                       "BMI",
                       "Age",
                       "Ethnicity",
                       "Introitus_pH",
                       "Posterior_fornix_pH",
                       "Temperature",
                       "Systolic_blood_pressure",
                       "Diastolic_blood_pressure",
                       "Pulse"
  )
  needed_metadata_names <-c ("Subject diet",
                             "Breast feeding",
                             "Subjects having given birth",
                             "Gender",
                             "BMI",
                             "Age",
                             "Ethnicity",
                             "Introitus pH",
                             "Posterior fornix pH",
                             "Temperature",
                             "Systolic blood pressure",
                             "Diastolic blood pressure",
                             "Pulse"
  )
  
  data <- df$Feature
  value <- NA
  simlarity_threshold = .005
  df$Coefficient[abs(df$Coefficient) < simlarity_threshold] <- 0
  value <- -log(df$Q.value)*sign(df$Coefficient)
  value <- pmax(-10, pmin(10, value))
  n <- length(unique(metadata))
  m <- length(unique(data))
  a = matrix(0, nrow=n, ncol=m)
  for (i in 1:length(metadata)){
    a[as.numeric(metadata)[i], as.numeric(data)[i]] <- value[i]
  }
  rownames(a) <- levels(metadata)
  colnames(a) <- levels(data)
  colnames(a) <-  sapply(colnames(a), pcl.sub )
  a <- a[, colSums(a != 0, na.rm = TRUE) > 0, drop=F]
  hc <- hclust(dist(t(a)), method="single")
  a <- a[,hc$order]
  
  
  return (a)
}
maaslin_heatmap <- function(title = "Metadata vs. OTUs", maaslin_output='./output/MaAsLin_OUTPUT_OTU/OTU.txt') {
  
  library(pheatmap)
  cell_value = "Q.value"
  data_label = 'Data'
  metadata_label = 'Metadata'
  border_color = "grey93"
  color = colorRampPalette(c("blue","whitesmoke", "red"))(51) #whitesmoke
  mat <- NA
  
  df_1 <- read.table( './output/MaAsLin_OUTPUT_OTU/OTU.txt',
                      header = TRUE, sep = "\t", fill = TRUE, comment.char = "" , check.names = FALSE)
  mat <- convert_maaslin_output2matrix(df_1)
  pdf(file="pheatmp.pdf", height = 25, width = 10)

  plot_result <- pheatmap(mat, cellwidth = 18, cellheight = 18,   # changed to 3
                          main = title,
                          fontsize = 15,
                          treeheight_row=0,
                          treeheight_column=0,
                          kmeans_k = NA,
                          border=TRUE,
                          show_rownames = T, show_colnames = T,
                          scale="none",
                          #clustering_method = "complete",
                          cluster_rows = F, cluster_cols = F,
                          treeheight_col = 0, 
                          clustering_distance_rows = "euclidean", 
                          clustering_distance_cols = "euclidean",
                          legend=T,
                          border_color = border_color,
                          color = color,
                          display_numbers = matrix(ifelse(mat > 0.0, "+", ifelse(mat < 0.0, "-", "")),  nrow(mat)))
  return (plot_result)
}

pcl.combine <- function(data, metadata, output='output_combine'){
  metadata <- read.csv( metadata, quote = NULL, header = TRUE, sep = "\t", fill = FALSE, comment.char = "" , check.names = FALSE)
  bugs <-pcl.read(data)
  data <- bugs$x
  pathways.unstrat <- pcl.filter.f(bugs, keep=!grepl("\\|", colnames(bugs$x)))
  #data <- pathways.unstrat$x
  meta <- bugs$meta
  #colnames(metadata) <-as.matrix(metadata["RANDSID",])
  temp_metadata = data.frame()
  temp_metadata <- rbind(temp_metadata,colnames(metadata) )
  colnames(temp_metadata) <- colnames(metadata)
  temp_metadata <- temp_metadata[0,]
  for (i in 1:length(rownames(data)) ) {
    for (j in 1:length(metadata[,"RANDSID"])) {
      #print (toString(pathways2["RANDSID",i]))
      if (meta[i,"RANDSID"]== metadata[j,"RANDSID"] && 
          toString(meta[i,"VISNO"]) == toString(metadata[j,"VISNO"])&&
            meta[i,"STSite"]== toString(metadata[j,"STSite"])){
        #print (metadata[j, ])
        #print (temp_metadata[i])
        temp_metadata<- rbind(temp_metadata,metadata[j,])
        break 
      }
    } 
  }
  rownames(temp_metadata) <-  rownames(data)
  
  temp_metadata2 <- temp_metadata[, c("RANDSID", "VISNO",  "STSite",	"DSUDIET_C",
                                      "DSUBFED_C",	"DVDTMPF",	"DVDINTPH",	"DVDPFPH",
                                      "GENDER_C",	"AGEENR",	"ETHNIC_C",	"StudyDay_Processed",
                                      "Originating_Site",	"Current_site",	"Number of Quality Bases",
                                      "Percent of Human Reads", "DTPSYSTL",	"DTPDIAST",
                                      "DTPPULSE", "DTPBMI")]
                                        #"DTPWTLB",  "DTPHTIN",
  rownames(temp_metadata2) <-  rownames(data)
  metadata_data <- cbind(temp_metadata2,data)
  dim(metadata_data)
  #write.table( t(metadata_data), '/Users/rah/Documents/HMP/maaslin/bug.txt', sep = "\t", eol = "\n", col.names = NA, row.names = T)
  #write.table( metadata_data, '/Users/rah/Documents/HMP/maaslin/bug.tsv', sep = "\t", eol = "\n", col.names = NA, row.names = T)
  return (metadata_data)
}