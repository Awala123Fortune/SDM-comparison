##########################################################################################
# OCCURRENCE PROBABILITIES
# resulting matrix: probabilties, nsites*nsp
##########################################################################################
require(abind)
source(file.path(SD, "pipe", "appendFilebody.r"))

ensmblModels <- ENS[[e]]

sp_occ_probs <- list() 

for (j in 1:3) {

	if ( !is.null(ensmblModels) ) {
		pred_names_tmp<-pred_names[ensmblModels]
		pred_comms_ensemble <- array(NA,
									 dim=list(dim(y_valid[[j]])[1],
									 		  dim(y_valid[[j]])[2],
									 		  1))
	} else {
		pred_names_tmp <- pred_names
		spOccProb <- array(NA,
						   dim=list(dim(y_valid[[j]])[1],
						   			dim(y_valid[[j]])[2],
						   			nmodels))
	}

	for (m in 1:length(pred_names_tmp)) {
		filebody <- paste0(pred_names_tmp[[m]],
	    				   		  j,
	    				   		  "_",
	    				   		  dataN[sz])
		if ( commSP ) {
			filebody <- paste0(filebody, "_commSP")
		}

    	model <- local({
	    	load(file.path(PD2, 
	    				   Sets[d],
	    				   paste0(filebody, ".RData")))
    		stopifnot(length(ls())==1)
    		environment()[[ls()]]
    	})

		pred_comms <- simplify2array(model)
		pred_comms <- as.array(pred_comms)

		if ( any(is(pred_comms) == "simple_sparse_array") ) {
			pred_comms<- array(pred_comms$v, dim=pred_comms$dim)
		}

		if ( !is.null(ensmblModels) ) {
			predSamp <- sample(1:REPs, ceiling(REPs/length(ensmblModels)))	
			pred_comms_ensemble <- abind(pred_comms_ensemble, pred_comms[,,predSamp])
		} else {
			tmp <- apply(pred_comms, c(1,2), mean)
    		spOccProb[,,m] <- tmp	
    		#spOccProb[,,m] <- (tmp*0.99)+0.005  	
			#To avoid singular cases due to the prediction being exactly 0 or 1, 
			#we transformed the probabilities by first multiplying them by 0.99 and then adding 0.005, 
			#so that they were in the range [0.005, 0.995] instead of the range [0,1]
		}
		rm(pred_comms) 
		gc()   
	}

	if ( !is.null(ensmblModels) ) {
		tmp <- pred_comms_ensemble[,,-1]
		spOccProb <- apply(tmp,c(1,2),mean)
		#spOccProb <- (spOccProb*0.99)+0.005  	
		rm(tmp)
	}		

	sp_occ_probs[[j]] <- spOccProb	
	rm(pred_names_tmp)
}

filebody <- file.path(RD2, Sets[d], "sp_occ_probs_")
filebody <- appendFilebody(filebody,
						   ensmblModels, 
						   nmodels, 
						   commSP, 
						   MCMC2)
save(sp_occ_probs, file=paste0(filebody, dataN[sz], ".RData"))

rm(sp_occ_probs)   
gc()   

##########################################################################################
