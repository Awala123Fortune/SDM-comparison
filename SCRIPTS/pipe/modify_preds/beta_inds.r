##########################################################################################
# COMMUNITY COMPOSITION
##########################################################################################
require(abind)
require(betapart)

ensmblModels <- ENS[[e]]

nsitepairs <- 300

beta_inds_site <- list()
beta_inds_site_valid <- list()

sitecombs <- combn(which(rowSums(y_train[[3]]) > 0), 2)
set.seed(17)
selsites <- sitecombs[, sample(1:ncol(sitecombs), 
						nsitepairs, 
						replace = TRUE)]

for (j in 1:3) {

	if ( !is.null(ensmblModels) ) {
		pred_names_tmp <- pred_names[ensmblModels]
		pred_comms_ensemble <- array(NA, dim=list(dim(y_valid[[j]])[1],
										 dim(y_valid[[j]])[2],
										 1))
		betaIndsSite <- array(NA, dim=list(nsitepairs, 3, REPs))
	} else {
		pred_names_tmp <- pred_names
		betaIndsSite <- array(NA, dim=list(nsitepairs, 3, REPs, nmodels))
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
		if ( any(is(pred_comms)== "simple_sparse_array") ) {
			pred_comms<- array(pred_comms$v, dim=pred_comms$dim)
		}

		if ( !is.null(ensmblModels) ) {
			predSamp <- sample(1:REPs, ceiling(REPs/length(ensmblModels)))	
			pred_comms_ensemble <- abind(pred_comms_ensemble, pred_comms[, , predSamp])
		} else {
			for (n in 1:REPs) {
				tmp1<-list()			
				tmp2<-list()			

				for (i in 1:nsitepairs) {
					tmp1[[i]] <- rbind(pred_comms[selsites[1,i],,n],
									   pred_comms[selsites[2,i],,n])
					#if (m==nmodels & n==REPs) {				
					tmp2[[i]] <- rbind(y_valid[[j]][selsites[1,i],],
									   y_valid[[j]][selsites[2,i],])
					#}
				}
				    		

				tmp3 <- matrix(unlist(lapply(tmp1,beta.pair)), ncol=3, byrow=T)
					tmp3[which(is.nan(tmp3[,1])),1] <- 0.995
					tmp3[which(is.nan(tmp3[,2])),2] <- 0.005
					tmp3[which(is.nan(tmp3[,3])),3] <- 0.995
				betaIndsSite[,,n,m] <- tmp3
				if (m==length(pred_names_tmp) & n==REPs) {				
					tmp4<-matrix(unlist(lapply(tmp2,beta.pair)), ncol=3, byrow=T)
					tmp4[which(is.nan(tmp4[,1])),1] <- 0.995
					tmp4[which(is.nan(tmp4[,2])),2] <- 0.005
					tmp4[which(is.nan(tmp4[,3])),3] <-  0.995
					beta_inds_site_valid[[j]] <- tmp4
				}
			}
		}

		rm(pred_comms) 
		gc()   
	}

	if ( !is.null(ensmblModels) ) {
		preds <- pred_comms_ensemble[,,-1]

		for (n in 1:REPs) {
			tmp1<-list()			

			for (i in 1:nsitepairs) {
				tmp1[[i]] <- rbind(preds[selsites[1,i],,n],
								   preds[selsites[2,i],,n])
			}
			tmp3 <- matrix(unlist(lapply(tmp1,beta.pair)), ncol=3, byrow=T)
				tmp3[which(is.nan(tmp3[,1])),1] <- 1
				tmp3[which(is.nan(tmp3[,2])),2] <- 0
				tmp3[which(is.nan(tmp3[,3])),3] <- 1
				betaIndsSite[,,n]<-tmp3
			rm(tmp1)
			rm(tmp3)
		}	
	rm(pred_comms_ensemble)
	}
	beta_inds_site[[j]]	<-	betaIndsSite
}

filebody <- file.path(RD2, Sets[d], "beta_inds_site_")
filebody <- appendFilebody(filebody,
						   ensmblModels, 
						   nmodels, 
						   commSP, 
						   MCMC2)
save(beta_inds_site, file=paste0(filebody, dataN[sz], ".RData"))
rm(beta_inds_site)   

if ( is.null(ensmblModels) ) {
	filebody <- file.path(RD2, Sets[d], "beta_inds_site_valid_")
	filebody <- appendFilebody(filebody,
							   ensmblModels, 
							   nmodels, 
							   commSP, 
							   MCMC2)
	save(beta_inds_site_valid, file=paste0(filebody, dataN[sz], ".RData"))
	rm(beta_inds_site_valid)   
}

gc()   

##########################################################################################

# tmpXerit<-matrix(c(c(0,1,0,1,1),c(1,0,1,0,0)),nrow=2,byrow=T)
# tmpXsamat<-matrix(c(c(0,1,0,1,1),c(0,1,0,1,1)),nrow=2,byrow=T)
# beta.pair(tmpXerit)
# beta.pair(tmpXsamat)