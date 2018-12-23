##########################################################################################
# HMSC PREDICTIONS FORMARTTING
##########################################################################################

if (intXs) {
	ms <- 1
} else {
	ms <- 3
}

for (m in 1:ms) {
	for (j in 1:3) {

		predsFile <- file.path(PD2,
					 		   set_no,
							   paste0("preds_",
							 	      set_no,
							 	      "_hmsc",
							 	      m,
							 	      "_d",
							 	      j,
							 	      "_",
							 	      dataN[sz]))		

		if (intXs) {
			predsFile <- paste0(predsFile, '_intXs')
		}		 	      
		if (commSP) {
			predsFile <- paste0(predsFile, '_commSP')
		}
		if (MCMC2) {
			predsFile <- paste0(predsFile, '_MCMC2')
		}

		preds <- read.csv(paste0(predsFile, ".csv"), header=FALSE)

		nsp <- ncol(y_valid[[j]])
		niter <- REPs

		if (m==1) {
			nsite <- nrow(y_valid[[j]])
		} else {
			nsite <- nrow(y_valid[[j]])+nrow(y_train[[j]])
		}

		hmsc_PAs <- array(as.matrix(preds), dim=list(nsite, nsp, niter))

		if (m != 1) {
			hmsc_PAs <- hmsc_PAs[(nrow(y_train[[j]])+1):nsite,,]
		}
		
		filebody <- paste0("hmsc",m)
		
		if (intXs) {
			filebody <- paste0(filebody, '_intXs')
		}

		filebody <- paste0(filebody, "_PAs_", j, "_", dataN[sz])
		
		if (commSP) {
			filebody <- paste0(filebody, '_commSP')
		}
		if (MCMC2) {
			filebody <- paste0(filebody, '_MCMC2')
		}

		save(hmsc_PAs, file=file.path(PD2,
									  set_no,
									  paste0(filebody, 
									  		 ".RData")))

		rm(preds)
		rm(hmsc_PAs)
		gc()
		}
	}

##########################################################################################
