##########################################################################################
# OCCURRENCE PROBABILITIES for MCMC2
# resulting matrix: probabilties, nsites*nsp
##########################################################################################
require(abind)

sp_occ_probs <- list() 

for (j in 1:3) {

		pred_names_tmp <- pred_names_bayes
		spOccProb <- array(NA,
						   dim=list(dim(y_valid[[j]])[1],
						   			dim(y_valid[[j]])[2],
						   			length(pred_names_bayes)))

	for (m in 1:length(pred_names_tmp)) {

		filebody <- paste0(pred_names_tmp[[m]],
	    				   		  j,
	    				   		  "_",
	    				   		  dataN[sz])
		if ( commSP ) {
			filebody <- paste0(filebody, "_commSP")
		}

		filebody <- paste0(filebody, "_MCMC2")
		filebody <- file.path(PD2, 
	    				   	  Sets[d],
	    				   	  paste0(filebody, 
	    				   	  		 ".RData"))
		
		if ( file.exists(filebody) ) {
			model <- local({
				load(filebody)
				stopifnot(length(ls())==1)
				environment()[[ls()]]
			})

			pred_comms <- simplify2array(model)
			pred_comms <- as.array(pred_comms)

			if ( any(is(pred_comms) == "simple_sparse_array") ) {
				pred_comms<- array(pred_comms$v, dim=pred_comms$dim)
			}
			tmp <- apply(pred_comms, c(1,2), mean)
			rm(pred_comms) 
			gc()   
		} else {
			tmp <- matrix(NA,
						  nrow=dim(y_valid[[j]])[1],
						  ncol=dim(y_valid[[j]])[2])			
		}
    	spOccProb[,,m] <- tmp	
    	#spOccProb[,,m] <- (tmp*0.99)+0.005  	
		#To avoid singular cases due to the prediction being exactly 0 or 1, 
		#we transformed the probabilities by first multiplying them by 0.99 and then adding 0.005, 
		#so that they were in the range [0.005, 0.995] instead of the range [0,1]
	}

	sp_occ_probs[[j]] <- spOccProb	
	rm(pred_names_tmp)

}

filebody <- file.path(RD2, Sets[d], "sp_occ_probs")
if ( commSP ) {
	filebody <- paste0(filebody, "_commSP")
}
filebody <- paste0(filebody, "_MCMC2_")
save(sp_occ_probs, file=paste0(filebody, dataN[sz], ".RData"))

rm(sp_occ_probs)   
gc()   

##########################################################################################