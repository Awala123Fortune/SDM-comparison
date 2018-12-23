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

for (sz in dszs) {
	for (d in 1:length(Sets)) {

			set_no <- Sets[d]; source(readdata)				
			source(file.path(modpredsFolder,"sp_occ_probs_MCMC2.r"))
			
	}
}

##########################################################################################
