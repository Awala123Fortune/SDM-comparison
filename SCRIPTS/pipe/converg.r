##########################################################################################
# CONVERGENCE CHECK OCCURRENCE PROBABILITIES
##########################################################################################
require(abind)

pred_names_tmp <- pred_names_bayes
convergs <- array(NA,
			  dim=list(length(pred_names_bayes),
					   dim(y_valid[[1]])[2],
					   3),
			  dimnames=list(names(pred_names_bayes),
							colnames(y_valid[[1]]),
							c("d2", "d2", "d3")))

# mcmc1
filebody <- file.path(RD2, Sets[d], "sp_occ_probs_")
if ( commSP ) {
	filebody <- paste0(filebody, "commSP_")
}
load(file=paste0(filebody, dataN[sz], ".RData"))
sp_occ_probs_mcmc1 <- sp_occ_probs
rm(sp_occ_probs)
sp_occ_probs_mcmc1 <- simplify2array(sp_occ_probs_mcmc1)
dimnames(sp_occ_probs_mcmc1) <- list(1:dim(simplify2array(sp_occ_probs_mcmc1))[1],
		  			 			     colnames(y_valid[[1]]),
			 			    		 names(pred_names),
			 			   			 c("d2", "d2", "d3"))
sp_occ_probs_mcmc1 <- sp_occ_probs_mcmc1[,,names(pred_names_bayes),]
dim(sp_occ_probs_mcmc1)

# mcmc2
filebody <- file.path(RD2, Sets[d], "sp_occ_probs_")
if ( commSP ) {
	filebody <- paste0(filebody, "commSP_")
}
filebody <- paste0(filebody, "MCMC2_")
load(file=paste0(filebody, dataN[sz], ".RData"))
sp_occ_probs_mcmc2 <- sp_occ_probs
rm(sp_occ_probs)
sp_occ_probs_mcmc2 <- simplify2array(sp_occ_probs_mcmc2)
dimnames(sp_occ_probs_mcmc2) <- list(1:dim(simplify2array(sp_occ_probs_mcmc2))[1],
		  			 			     colnames(y_valid[[1]]),
			 			    		 names(pred_names_bayes),
			 			   			 c("d2", "d2", "d3"))


# correlations
for (j in 1:3) {
	for (m in 1:dim(sp_occ_probs_mcmc1)[3]) {
		for (k in 1:dim(sp_occ_probs_mcmc1)[2]) {

			convergs[m,k,j] <- cor( sp_occ_probs_mcmc1[,k,m,j], 
									sp_occ_probs_mcmc2[,k,m,j])
		}
	}
}		

filebody <- file.path(RD2, Sets[d], "covergence_")
if ( commSP ) {
	filebody <- paste0(filebody, "commSP_")
}
save(convergs, file=paste0(filebody, dataN[sz], ".RData"))

rm(sp_occ_probs_mcmc1)   
rm(sp_occ_probs_mcmc2)   
rm(convergs)   
gc()   

##########################################################################################