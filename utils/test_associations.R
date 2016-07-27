library(Maaslin)
library(gamlss)
#example(Maaslin)
Maaslin('../output/MODULE.pcl','../output/MODULE',
        strInputConfig='../input/input.read.config', dSignificanceLevel =.1)#, fZeroInflated = TRUE
Maaslin('../output/OTU.pcl','../output/OTU',
        strInputConfig='../input/input.read.config.otu', dSignificanceLevel =.1)#, fZeroInflated = TRUE

graphics.off()
