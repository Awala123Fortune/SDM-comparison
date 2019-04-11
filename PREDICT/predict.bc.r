##########################################################################################
# BayesComm PREDICTIONS
##########################################################################################

require(BayesComm)

##########################################################################################

for (j in 1:3) {	
	if (!commSP) {
		load(file = file.path(FD2,
							  set_no,
							  paste0("no0sp_BC_",
								     j,
								     "_",
								     dataN[sz],
								     ".RData")))
  	}
  	
	for (m in 1:2) {

        modelfile <- file.path(FD2, set_no, paste0("bc",
                                                   m,
                                                   "_",
                                                   j,
                                                   "_",
                                                   dataN[sz]))
		if (MCMC2) {
			modelfile <- paste0(modelfile, "_MCMC2")
		}		
		
		load(file = paste0(modelfile, ".RData"))

		if (m==1) { bc <- bc1}
		if (m==2) { bc <- bc2}

		Xv <- x_valid[[j]][,-1]		
		
		bc_pred <- predict(bc, 
						   newdata=Xv, 
						   type="terms")
		tmp <- rbinom(bc_pred, 1, bc_pred)
		bc_PAs <- array(tmp,
						dim=list(dim(bc_pred)[1],
								 dim(bc_pred)[2],
								 dim(bc_pred)[3]))

		if (!commSP) {
			bc_pred_w0sp <- array(NA, dim=list(nrow(y_valid[[j]]),
											   ncol(y_valid[[j]]),
											   dim(bc_pred)[3]),
									  dimnames=list(1:nrow(y_valid[[j]]),
									  colnames(y_valid[[j]]),
									  1:dim(bc_pred)[3]))			

			for (i in 1:dim(bc_pred)[3]) {
				bc_pred_w0sp[,,i]<-rbinom(colMeans(y_train[[j]]),
										  1,
										  colMeans(y_train[[j]]))
				bc_pred_w0sp[,no0spNames,i] <- bc_PAs[,,i]
			}
			bc_PAs <- bc_pred_w0sp
		}

		filebody <- paste0("bc", m, "_PAs_", j, "_", dataN[sz])

		if (commSP) {
			filebody <- paste0(filebody, "_commSP")
		}		
		if (MCMC2) {
			filebody <- paste0(filebody, "_MCMC2")
		}		

		save(bc_PAs, file=file.path(PD2,
									set_no,
									paste0(filebody, ".RData")))
		rm(bc_pred_w0sp)
		rm(bc_pred)
		rm(bc_PAs)	
		gc()	
	}
	if (!commSP) { rm(no0spNames) }
	gc()	
}	
##########################################################################################
	
