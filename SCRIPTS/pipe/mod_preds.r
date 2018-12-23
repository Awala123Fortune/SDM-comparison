##########################################################################################
# MODIFY PREDICTIONS
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

modPredScrs <- c(file.path(modpredsFolder,"sp_occ_probs.r"),
 				 file.path(modpredsFolder,"sp_rich_site.r"),
 				 file.path(modpredsFolder,"beta_inds.r"))		
#modPredScrs <- c(file.path(modpredsFolder,"beta_inds.r"))		

for (sz in dszs) {
	for (e in 1:length(ENS)) {			
		for (d in 1:length(Sets)) {
			set_no <- Sets[d]; source(readdata)				
			foreach	(i=1:length(modPredScrs)) %dopar% { source(modPredScrs[i]) } 
		}
	}
}

##########################################################################################
