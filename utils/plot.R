#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
library(pheatmap)
library(ggplot2)
library(cowplot)

source('~/Documents/Hutlab/american_gut/utils/r_utils.R')
# Creat a dirctory for Figures 
dir.create(file.path("./output", "Figures"), showWarnings = FALSE)
# plot associations
otu <- read.table('./output/MaAsLin_INPUT/OTU.tsv', 
                    quote = "\"", header = TRUE, row.names = 1, sep = "\t", fill = FALSE,
                    comment.char = "" , check.names = FALSE)
#fornix <- data.frame(t(fornix))
otu[otu == ""] <- NA
otu$k_Bacteria_p_Cyanobacteria <- as.double(otu$k_Bacteria_p_Cyanobacteria)
otu$k_Bacteria_p_Cyanobacteria[otu$k_Bacteria_p_Cyanobacteria > .002] <- NA
otu$ANTIBIOTIC_HISTORY <- as.factor(otu$ANTIBIOTIC_HISTORY) 
abx_plot <- ggplot(na.omit(otu[, c("ANTIBIOTIC_HISTORY", "k_Bacteria_p_Cyanobacteria")]),
                          (aes(x=factor(ANTIBIOTIC_HISTORY), y=k_Bacteria_p_Cyanobacteria) ), size = .5)
abx_plot <- abx_plot+ geom_boxplot(notch=T, outlier.shape=NA, fill= "saddlebrown", alpha=0.75)+
  theme(axis.text.x = element_text(angle = 0, vjust = 0.5, hjust=0.5)) + geom_jitter(width = 0.5, size = I(2), alpha = I(0.25))+
  xlab("Antibiotic history") +  ylab("Cyanobacteri abundance") + 
  guides(fill = guide_legend(title = "abundance")) + theme(legend.justification=c(0,0), legend.position=c(0,.75))+
  theme(plot.title = element_text(face="bold",size = rel(1.25)))+
  labs(title = "Antibiotic history" )
abx_plot  
ggsave(filename='./output/Figures/abx_plot.pdf', plot=abx_plot, width = 10, height = 5, units = "in", dpi = 300)

otu$k_Bacteria_p_Firmicutes_c_Clostridia_o_Clostridiales_f_Lachnospiraceae <- as.double(otu$k_Bacteria_p_Firmicutes_c_Clostridia_o_Clostridiales_f_Lachnospiraceae)
otu$k_Bacteria_p_Firmicutes_c_Clostridia_o_Clostridiales_f_Lachnospiraceae[otu$k_Bacteria_p_Firmicutes_c_Clostridia_o_Clostridiales_f_Lachnospiraceae > .4] <- NA
abx_plot2 <- ggplot(na.omit(otu[, c("ANTIBIOTIC_HISTORY", "k_Bacteria_p_Firmicutes_c_Clostridia_o_Clostridiales_f_Lachnospiraceae")]),
                   (aes(x=factor(ANTIBIOTIC_HISTORY), y=k_Bacteria_p_Firmicutes_c_Clostridia_o_Clostridiales_f_Lachnospiraceae) ), size = .5)
abx_plot2 <- abx_plot2 + geom_boxplot(notch=T, outlier.shape=NA, fill= "saddlebrown", alpha=0.75)+
  theme(axis.text.x = element_text(angle = 0, vjust = 0.5, hjust=0.5)) + geom_jitter(width = 0.5, size = I(2), alpha = I(0.25))+
  xlab("Antibiotic history") +  ylab("Lachnospiraceae") + 
  guides(fill = guide_legend(title = "abundance")) + theme(legend.justification=c(0,0), legend.position=c(0,.75))+
  theme(plot.title = element_text(face="bold",size = rel(1.25)))+
  labs(title = "Antibiotic history" )
abx_plot2  
ggsave(filename='./output/Figures/abx_plot2.pdf', plot=abx_plot2, width = 10, height = 5, units = "in", dpi = 300)


otu$k_Bacteria_p_Proteobacteria_c_Gammaproteobacteria_o_Pasteurellales_f_Pasteurellaceae <- as.double(otu$k_Bacteria_p_Proteobacteria_c_Gammaproteobacteria_o_Pasteurellales_f_Pasteurellaceae)
otu$k_Bacteria_p_Proteobacteria_c_Gammaproteobacteria_o_Pasteurellales_f_Pasteurellaceae[otu$k_Bacteria_p_Proteobacteria_c_Gammaproteobacteria_o_Pasteurellales_f_Pasteurellaceae > .05] <- NA
otu$COUNTRY <- as.factor(otu$COUNTRY)
country_plot <- ggplot(na.omit(otu[, c("COUNTRY", "k_Bacteria_p_Proteobacteria_c_Gammaproteobacteria_o_Pasteurellales_f_Pasteurellaceae")]),
                    (aes(x=factor(COUNTRY), y=k_Bacteria_p_Proteobacteria_c_Gammaproteobacteria_o_Pasteurellales_f_Pasteurellaceae) ), size = .5)
country_plot <- country_plot + geom_boxplot(notch=T, outlier.shape=NA, fill= "saddlebrown", alpha=0.75)+
  theme(axis.text.x = element_text(angle = 0, vjust = 0.5, hjust=0.5)) + geom_jitter(width = 0.5, size = I(2), alpha = I(0.25))+
  xlab("Country") +  ylab("Pasteurellaceae") + 
  guides(fill = guide_legend(title = "abundance")) + theme(legend.justification=c(0,0), legend.position=c(0,.75))+
  theme(plot.title = element_text(face="bold",size = rel(1.25)))+
  labs(title = "Country" )
country_plot  
ggsave(filename='./output/Figures/country_plot.pdf', plot=country_plot, width = 8, height = 5, units = "in", dpi = 300)

otu$k_Bacteria_p_Firmicutes_c_Erysipelotrichi_o_Erysipelotrichales_f_Erysipelotrichaceae_g_Holdemania <- as.double(otu$k_Bacteria_p_Firmicutes_c_Erysipelotrichi_o_Erysipelotrichales_f_Erysipelotrichaceae_g_Holdemania)
otu$k_Bacteria_p_Firmicutes_c_Erysipelotrichi_o_Erysipelotrichales_f_Erysipelotrichaceae_g_Holdemania[otu$k_Bacteria_p_Firmicutes_c_Erysipelotrichi_o_Erysipelotrichales_f_Erysipelotrichaceae_g_Holdemania > .05] <- NA
otu$IBD <- as.factor(otu$IBD)
IBD_plot <- ggplot(na.omit(otu[, c("IBD", "k_Bacteria_p_Firmicutes_c_Erysipelotrichi_o_Erysipelotrichales_f_Erysipelotrichaceae_g_Holdemania")]),
                       (aes(x=factor(IBD), y=k_Bacteria_p_Firmicutes_c_Erysipelotrichi_o_Erysipelotrichales_f_Erysipelotrichaceae_g_Holdemania) ), size = .5)
IBD_plot <- IBD_plot + geom_boxplot(notch=T, outlier.shape=NA, fill= "saddlebrown", alpha=0.75)+
  theme(axis.text.x = element_text(angle = 0, vjust = 0.5, hjust=0.5)) + geom_jitter(width = 0.5, size = I(2), alpha = I(0.25))+
  xlab("Country") +  ylab("Holdemania") + 
  guides(fill = guide_legend(title = "abundance")) + theme(legend.justification=c(0,0), legend.position=c(0,.75))+
  theme(plot.title = element_text(face="bold",size = rel(1.25)))+
  labs(title = "IBD" )
IBD_plot  
ggsave(filename='./output/Figures/IBD_plot.pdf', plot=IBD_plot, width = 5, height = 5, units = "in", dpi = 300)

otu$k_Bacteria_p_Actinobacteria_c_Actinobacteria_o_Bifidobacteriales <- as.double(otu$k_Bacteria_p_Actinobacteria_c_Actinobacteria_o_Bifidobacteriales)
otu$k_Bacteria_p_Actinobacteria_c_Actinobacteria_o_Bifidobacteriales[otu$k_Bacteria_p_Actinobacteria_c_Actinobacteria_o_Bifidobacteriales > .05] <- NA
otu$AGE_CORRECTED <- as.double(otu$AGE_CORRECTED)
AGE_plot <- ggplot(na.omit(otu[, c("AGE_CORRECTED", "k_Bacteria_p_Actinobacteria_c_Actinobacteria_o_Bifidobacteriales")]),
                   (aes(x=AGE_CORRECTED, y=k_Bacteria_p_Actinobacteria_c_Actinobacteria_o_Bifidobacteriales) ), size = .5)
AGE_plot <- AGE_plot + theme(plot.title = element_text(face="bold",size = rel(1.25)))+
  labs(title = "Age")+
  theme(text = element_text(size=15),axis.text.x = element_text(angle = 0, hjust = 1), axis.text.y = element_text(size =15,angle = 0, hjust = 1))+
  #geom_abline(slope =1.0, linetype = 2, colour= 'red') +
  stat_smooth(method = "glm") + #expand_limits(x=0, y=0) +
  geom_point(size = I(2), alpha = I(0.25)) +
  xlab("Age") +  ylab("Bifidobacteriales")
AGE_plot 
ggsave(filename='~/Documents/HMP/Figures/AGE_plot.pdf', plot=AGE_plot, width = 5, height = 5, units = "in", dpi = 300)


ggsave(filename='./output/Figures/AGE_plot.pdf', plot=AGE_plot, width = 5, height = 5, units = "in", dpi = 300)

all_heatmap <- maaslin_heatmap(title = "Metadata vs. OTUs", maaslin_output='./output/MaAsLin_OUTPUT_OTU/OTU.txt') 
bug_metadata_overview <-ggdraw() + 
  draw_plot(all_heatmap$gtable , x = 0.01, y = 0.4, 1, .6) +
  draw_plot(abx_plot, 0.0, 0, 0.2, 0.4) +
  draw_plot(abx_plot2, .2, 0, 0.2, 0.4) +
  draw_plot(country_plot, .4, 0, 0.2, 0.4) +
  draw_plot(IBD_plot, .6, 0, 0.15, 0.4) +
  draw_plot(AGE_plot, .75, 0, 0.2, 0.4) +
  draw_plot_label((label = c("A", "B", "C", "D", "E", "F")),  #Anterior nares  Buccal Mucosa Supragingivalplaque Tongue dorsum Stool Posterior fornix
                  
                  size = 20, x = c(0, 0, .2, .4, 0.6, .75), y = c(1, .4, .4, .4, .4,.4))

bug_metadata_overview
ggsave(filename='./output/Figures/Fig5_associations_overview.pdf', plot=bug_metadata_overview, width = 30, height = 13, units = "in", dpi = 200)
try(temp<-dev.off(), silent=TRUE)

#maaslin_heatmap(title = "Metadata vs. Metabolomic Modules",  output_file='./output/MaAsLin_OUTPUT_MODULE/MODULE.pdf',
#                maaslin_output='./output/MaAsLin_OUTPUT_MODULE/MODULE.txt', cell_value ="Q.value", data_label = "Pathways")
                
             