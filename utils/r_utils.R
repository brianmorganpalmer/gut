# -----------------------------------------------------------------------------
#  MaAsLin  Output HEATMAP
pcl.sub <- function(x){
  #return(x)
  x <- strsplit(x, "__", fixed= TRUE)
  l <- length(x[[1]])
  x <- x[[1]][l][1]
  x <- gsub("__", "_", x)
  x <- gsub("__", "_", x)
  #x <- paste(paste(x[[1]][l-2][1], x[[1]][l-1][1]), x[[1]][l][1])
  #x <- gsub("__", "_", x)
  #x <- gsub("__", "_", x)
  #x <- gsub(" ", "", x)
  #if (x == 'g1_68')
  #  x <- 'Tissierellaceae_g_1_68'
  return(x)
}
maaslin_heatmap <- function(maaslin_output, output_file = "pheatmap.pdf", title = "", cell_value = "Q.value", data_label = 'Data', metadata_label = 'Metadata',
                   border_color = "grey93", color = colorRampPalette(c("blue","grey90", "red"))(500)) {#)
  
  library('pheatmap')
  # read MaAsLin output
  df <- read.table( maaslin_output,
                    header = TRUE, sep = "\t", fill = TRUE, comment.char = "" , check.names = FALSE)
  metadata <- df$Variable
  data <- df$Feature
  value <- NA
  # values to use for coloring the heatmap
  if (cell_value == "P.value"){
    value <- -log(df$P.value)*sign(df$Coefficient)
    value <- pmax(-10, pmin(10, value))
  }else if(cell_value == "Q.value"){
    value <- -log(df$Q.value)*sign(df$Coefficient)
    value <- pmax(-10, pmin(10, value))
  }else if(cell_value == "Coefficient"){
    value <- df$Coefficient
  }
  n <- length(unique(metadata))
  m <- length(unique(data))
  a = matrix(0, nrow=n, ncol=m)
  for (i in 1:length(metadata)){
      #if (abs(a[as.numeric(metadata)[i], as.numeric(metadata)[i]]) >= abs(value[i]))
      #    next
      a[as.numeric(metadata)[i], as.numeric(data)[i]] <- value[i]
  }
  rownames(a) <- levels(metadata)
  colnames(a) <- levels(data)
  
  colnames(a) <-  sapply(colnames(a), pcl.sub )
  #rownames(a) <-  sapply(rownames(a), pcl.sub )
  pdf(file=output_file, height = length(rownames(a))/5+8, width = length(colnames(a))/5+5)
  
  pheatmap(a, cellwidth = NA, cellheight = NA,   # changed to 3
            main = title,
            treeheight_row=0,
            treeheight_column=0,
            kmeans_k = NA,
            border=TRUE,
            show_rownames = T, show_colnames = T,
            scale="none",
            #clustering_method = "complete",
            cluster_rows = TRUE, cluster_cols = TRUE,
            clustering_distance_rows = "euclidean", 
            clustering_distance_cols = "euclidean",
            legend=TRUE,
            border_color = border_color,
            color = color,
            display_numbers = matrix(ifelse(a > 0.0, "+", ifelse(a < 0.0, "|", "")),  nrow(a)))
  try(temp<-dev.off(), silent=TRUE)
}

pcl.merge_slurmlog_humann2_log<- function(slurm_log_file ='/Users/rah/Documents/HMP/metadata/performance_humann2_hmp1_II.txt', 
                               humann2_log_file ='/Users/rah/Documents/HMP/metadata/hmp1-II_humann2_logs.pcl'){
  # Merge HUMAnN2 log and SLURM log for HMP1-II samples
  performance_humann2_log <- read.table( humann2_log_file, header = TRUE, row.names = 1,sep = "\t", fill = FALSE, comment.char = "" , check.names = FALSE)
  colnames(performance_humann2_log) <- gsub(".log", "", colnames(performance_humann2_log))
  performance_slurm_log <- read.table( slurm_log_file, header = TRUE, row.names = 1,sep = "\t", fill = FALSE, comment.char = "" , check.names = FALSE)
  performance_slurm_log <- t(performance_slurm_log)
  metadata <- read.table( '/Users/rah/Documents/HMP/metadata/hmp1-II_public_metadata.pcl', quote = NULL, header = TRUE, row.names = 1, sep = "\t", fill = FALSE, comment.char = "" , check.names = FALSE)
  performance_humann2_log <- performance_humann2_log[rownames(performance_humann2_log), order(colnames(performance_slurm_log))]
  performance_slurm_log <- performance_slurm_log[rownames(performance_slurm_log), order(colnames(performance_slurm_log))]
  metadata <- metadata[,metadata["SRS",]!="#N/A" ]
  metadata <- metadata[, order(metadata["SRS",])]
  colnames(performance_slurm_log)
  colnames(metadata) <-as.matrix(metadata["SRS",])
  needed.metadata <- metadata[, colnames(metadata) %in% colnames(performance_slurm_log)]
  slurm_humann2_hmp1_ii_log <- rbind(as.matrix(needed.metadata),as.matrix(performance_slurm_log),as.matrix(performance_humann2_log))
  write.table( slurm_humann2_hmp1_ii_log, '/Users/rah/Documents/HMP/metadata/slurm_humann2_hmp1_ii_log.txt', sep = "\t", eol = "\n", quote = F, col.names = NA, row.names = T)
  return (slurm_humann2_hmp1_ii_log) 
}
## Edit body of pheatmap:::draw_colnames, customizing it to your liking
#draw_colnames_45 <- function (coln, ...) {
#  m = length(coln)
#  x = (1:m)/m - 1/2/m
#  grid.text(coln, x = x, y = unit(0.96, "npc"), vjust = .5, 
#            hjust = 0, rot = 270, gp = gpar(...)) ## Was 'hjust=0' and 'rot=270'
#}
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
