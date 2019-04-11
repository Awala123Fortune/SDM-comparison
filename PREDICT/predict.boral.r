##########################################################################################
# BAYESIAN ORDINATIO AND REGRESSION ANALYSIS PREDICTIONS
##########################################################################################

require(boral)
source(file.path(PD,"boralPredict.r"))
require(abind)

##########################################################################################

for (j in 1:3) {

	nsites <- nrow(x_valid[[j]])
	nsp <- ncol(y_valid[[j]])

	for (m in 1:2) {

        modelfile <- file.path(FD, set_no, paste0("brl",
                                                   m,
                                                   "_",
                                                   j,
                                                   "_",
                                                   dataN[sz]))
		if (MCMC2) {
			modelfile <- paste0(modelfile, "_MCMC2")
		}		
		
		load(file = paste0(modelfile, ".RData"))

		if (m==1) { brl <- brl1 }
		if (m==2) { brl <- brl2 }

		Xv <- x_valid[[j]][,-1] 

		linpred_boral <- boralPredict(brl, 
									  newX = Xv, 
									  predict.type = "marginal")
		boral_PAs <- linpred_boral
		for(k in 1:dim(linpred_boral)[3]) {
		    boral_PAs[,,k] <- matrix(rbinom(length(linpred_boral[,,k]), 
		    								1, 
		    								prob = pnorm(linpred_boral[,,k])), 
		    						 nrow = dim(linpred_boral)[1], 
		    						 ncol = dim(linpred_boral)[2])
		}
		set.seed(17)
		smplREPs <- sample(1:dim(boral_PAs)[3], 
						   REPs, 
						   replace = T)
		boral_PAs <- boral_PAs[,,smplREPs]

		filebody <- paste0("boral", m, "_PAs_", j, "_", dataN[sz])
		if (commSP) {
			filebody <- paste0(filebody, "_commSP")
		}		
		if (MCMC2) {
			filebody <- paste0(filebody, "_MCMC2")
		}		

		save(boral_PAs, file = file.path(PD2,
	    	                             set_no,
	        	                         paste0(filebody, ".RData")))
	        	                       
		rm(brl)
		rm(linpred_boral)
		rm(boral_PAs)
		gc()

	}
}	

##########################################################################################
