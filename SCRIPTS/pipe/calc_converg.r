##########################################################################################
# CONVERGENCE CHECK
##########################################################################################

rm(list=ls()[!(ls() %in% c("OS",
						   "pth",
						   "SETT",
						   "ENS",
						   "PRVthr",
						   "MCMC2",
						   "commSP",
						   "intXs",
						   "dszs"))]) 
gc(); source(SETT); setwd(WD)

source(file.path(SD, "pipe", "appendFilebody.r"))

for (sz in dszs) {
	for (d in 1:length(Sets)) {

			set_no <- Sets[d]; source(readdata)				
			source(file.path(SD,"pipe","converg.r"))
			
	}
}

##########################################################################################

convgsAllTaxons <- NA
for (sz in dszs) {
	for (d in 1:length(Sets)) {

			set_no <- Sets[d]

			filebody <- file.path(RD2, Sets[d], "covergence_")
			if ( commSP ) {
				filebody <- paste0(filebody, "commSP_")
			}
			load(file=paste0(filebody, dataN[sz], ".RData"))
			
			print( paste("Data size:", 
				 		 sz, 
				 		 ", Data set:", 
				 		 Sets[d], 
				 		 "; no. of na(n)s", 
				 		 sum(is.na(convergs) + is.nan(convergs))) )
			
			tmp <- as.vector(apply(convergs, 3, rowMeans, na.rm = TRUE))
			convgs_for_taxon <- cbind(rep(names(pred_names_bayes), 3) ,tmp, set_no, rep(c('i', 'e1', 'e2'), 
									  each=length(pred_names_bayes)), dataN[sz])
			convgsAllTaxons <- 	rbind(convgsAllTaxons, convgs_for_taxon)					  
	}
}
convgsAllTaxons <- convgsAllTaxons[-1, ]
colnames(convgsAllTaxons) <- c('model', 'correlation', 'taxon', 'data_type', 'data_size')
write.table(convgsAllTaxons, 
			file=file.path(RDfinal, "convergences.csv"), 
			sep=",", 
			row.names = FALSE,
            col.names = TRUE)

##########################################################################################
