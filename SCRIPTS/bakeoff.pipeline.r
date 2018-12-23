##########################################################################################
# BAKEOFF SDM COMPARISON PIPELINE
##########################################################################################

# preliminaries
##########################################################################################
rm(list = ls(all=TRUE)); gc()	# clear workspace

pth <- "..." 	# write here the path to the location of the 'bakeoff' folder

WD <- file.path(pth, "bakeoff", "pipeline")
setwd(WD)										# set working directory to the pipeline folder
SD <- file.path(WD, "SCRIPTS")
SETT <- file.path(SD, "settings.r")				# path to settings

source(file.path(SD,"pipe", "get_os.r"))		# identify your OS
source(file.path(SD,"pipe", "pkgs.r"))			# install required packages, 
source(file.path(SD,"pipe", "dirs.r"))			# create directories (if don't exist),
source(file.path(SD,"pipe", "parall.r"))		# and define settings for parallel computing

# basic settings one needs to run before each block
##########################################################################################

MCMC2 <- FALSE
commSP <- FALSE
intXs <- FALSE

source(SETT)		# run settings

#1 model fitting & predictions
##########################################################################################

for (sz in dszs) {
	for (d in 1:length(Sets)) {
	
		set_no <- Sets[d]
		source(readdata)

		source(fitmodels)
		source(makepreds)
		
	}
}


#2 performance measures (PM)
##########################################################################################
MCMC2 <- FALSE
commSP <- FALSE
intXs <- FALSE

source(SETT)

ENS<-list(NULL, unlist(mod_names) ,c("HMSC3", "GLM5", "MISTN1", "GNN1", "MARS1"))
dszs <- c(1, 3)

if (commSP) { 
	PRVthr <- 0.1 
	source(mod_commSP)
}

source(modpreds)
source(pms)
source(pms_comb)
source(pms_tbl)
source(pms_plot)

# combine commSP and full results
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

load(file=file.path(RDfinal, "TBL_PMS_ALL.RData"))
res_all <- cbind(TBL_PMS_ALL, 1)
rm(TBL_PMS_ALL)
load(file=file.path(RDfinal, "TBL_PMS_ALL_commSP.RData"))
res_commsp <- cbind(TBL_PMS_ALL, 0.1)
rm(TBL_PMS_ALL)


TBL_COMB <- rbind(res_all, res_commsp)
colnames(TBL_COMB)[ncol(TBL_COMB)] <- "prev_threshold"

tmp <- apply(TBL_COMB[,13:ncol(TBL_COMB)],2,as.numeric)
sum(is.na(tmp))
which(is.na(tmp),arr.ind=T)

save(TBL_COMB, file=file.path(RDfinal, "TBL_COMB.RData"))
write.table(TBL_COMB,
			file=file.path(RDfinal,"TBL_COMB.csv"),
			sep=",",
			row.names=F,
			col.names=T)					

#4 species occurrence probabilities for MCMC2 chains and covergence check
##########################################################################################

source(mcmc2modpreds)
source(calcConvergence)

##########################################################################################




