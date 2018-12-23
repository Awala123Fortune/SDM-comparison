##########################################################################################
# STATISTICAL METHODS FOR ANALYSING MULTIVARIATE ABUNDANCE DATA PREDICTIONS
##########################################################################################

require(mvabund)
require(boot)

traitglmboot <- function(data,
 						nsp,
						ncovar, 
						valid_data_X,
						family = binomial(link = "logit"), 
						method = "glm1path", 
						indices)
{

  indices <- sample(1:nrow(data), size=nrow(data), replace = TRUE)
  d_sub <- data[indices,]
  Y_sub <- d_sub[,1:nsp]
  X_sub <- d_sub[,(1+nsp):(nsp+ncovar)]
  fit <- traitglm(L = Y_sub, 
  				  R = X_sub, 
  				  method = "glm1path", 
  				  family = binomial(link = "logit"))
  preds <- predict(fit, newR = valid_data_X)
  #return(fit$coefficients)
  return(preds)
}

##########################################################################################

for (j in 1:3) {

	if (j==1) { sT<-Sys.time() }

	traitglm_boostr <- boot(data = cbind(y_train[[j]], 
										 x_train[[j]][,-1]),
				   		    parallel = "multicore",
				   		    ncpus = 10,
				   		    statistic = traitglmboot, 
				   		    R = 100,
 				   		    nsp = ncol(y_train[[j]]),
				   		    ncovar = ncol(x_train[[j]][,-1]),
				   		    valid_data_X = x_valid[[j]][,-1])	

	if (j==1) {
		eT<-Sys.time()
		comTimes<-eT-sT
		}

	tmp <- foreach (i=1:REPs) %dopar% { rbinom(traitglm_boostr$t[i,], 
											   1, 
											   traitglm_boostr$t[i,]) 
									  }
	traitglm1b_PAs <- simplify2array(lapply(tmp, 
											matrix, 
											nrow=nrow(x_valid[[j]]),
											ncol=ncol(y_train[[j]])))

	save(traitglm1b_PAs, 
		 file=file.path(PD2, 
					    set_no, 
					    paste("traitglm1b_PAs_",
						 	 j,
						 	 "_",
							 dataN[sz],
							 ".RData",
							 sep="")))
	if (j==1) { 
		save(comTimes, 
			 file=file.path(FD,
			 				set_no,
			 				paste("comTimes_TRAITGLM1b_",
			 					   dataN[sz],
			 					   ".RData",
			 					   sep=""))) 
		rm(comTimes)
	}

	rm(traitglm1b_PAs)
	rm(tmp)
	rm(traitglm_boostr)
	gc()
	
	}
##########################################################################################
