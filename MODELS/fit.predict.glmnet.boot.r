##########################################################################################
# GLMNET WITH PARAMETER UNCERTAINTY	(bootstrapping)
##########################################################################################

require(glmnet)
require(boot)

glmnetboot <- function(data,
 						nsp,
						ncovar, 
						valid_data_X,
						param_lambdas = NULL, 
						indices)
{

  	indices <- sample(1:nrow(data), size=nrow(data), replace = TRUE)

  	d_sub <- data[indices,]
  	Y_sub <- d_sub[,1:nsp]
  	X_sub <- d_sub[,(1+nsp):(nsp+ncovar)]

	glmnets <- vector("list", nsp) 
	for (i in 1:nsp) { 
		glmnets[[i]] <- tryCatch({ glmnet(	y = as.matrix(Y_sub[,i]), 
											x = as.matrix(X_sub),
											family = "binomial", 
						    				alpha = 1, 
											lambda = param_lambdas[[i]], 
											standardize = FALSE, 
											intercept = TRUE)},
 								error=function(e){cat("ERROR :",
 								conditionMessage(e), "\n")})
		}						
	
# 	preds	<-	foreach	(i=1:nsp) %dopar% { 
#   		tryCatch({ predict(glmnets[[i]], newx = valid_data_X, s = 'lambda.min')},
# 						error=function(e){cat("ERROR :",
# 						conditionMessage(e), "\n")}) 
# 	}

	preds <- vector("list", nsp) 
	for (i in 1:length(glmnets)) { 
	  if ( !is.null(glmnets[[i]]) ) {
	    preds[[i]] <- predict(glmnets[[i]], 
  						   			newx = valid_data_X,
  						   			type = "response")
	    }
	}

	for (i in 1:length(preds)) {
		if ( is.null(preds[[i]]) ) {
			preds[[i]] <- matrix(rep(mean(Y_sub[,i]), 
									 times=nrow(valid_data_X)),
								 ncol = 1)
		}
	}

	return( matrix(unlist(preds), ncol=nsp) )
}

##########################################################################################
citation('glmnet')
for (j in 1:3) {

	if (j==1) { sT<-Sys.time() }

	load(file = file.path(PD2, 
			 	set_no, 
		 		paste("glmnet_minBIClambdas_", 
		 		j, 
		 		"_", 
		 		dataN[sz], 
		 		".RData",sep="")))						 	  		

	for (i in 1:length(minBIClambdas)) {
		if ( is.null(minBIClambdas[[i]]) ) {
			minBIClambdas[[i]] <- median(unlist(minBIClambdas))
		}
	}

	glmnet_boostr <- boot( data = cbind(y_train[[j]], 
										x_train[[j]][,-1]),
				   		    parallel = "multicore",
				   		    ncpus = 2,
				   		    statistic = glmnetboot, 
				   		    param_lambdas = minBIClambdas,
				   		    R = REPs,
 				   		    nsp = ncol(y_train[[j]]),
				   		    ncovar = ncol(x_train[[j]][,-1]),
				   		    valid_data_X = x_valid[[j]][,-1] )	

	if (j==1) {
		eT<-Sys.time()
		comTimes<-eT-sT
		}

	tmp <- foreach (i=1:REPs) %dopar% { rbinom(glmnet_boostr$t[i,], 
											   1, 
											   glmnet_boostr$t[i,]) 
									  }

	glmnet1b_PAs <- simplify2array(lapply(tmp, 
											matrix, 
											nrow=nrow(x_valid[[j]]),
											ncol=ncol(y_train[[j]])))

	save(glmnet1b_PAs, 
		 file=file.path(PD2, 
					    set_no, 
					    paste("glmnet1b_PAs_",
						 	 j,
						 	 "_",
							 dataN[sz],
							 ".RData",
							 sep="")))
	if (j==1) { 
		save(comTimes, 
			 file=file.path(FD,
			 				set_no,
			 				paste("comTimes_GLMNET1b_",
			 					   dataN[sz],
			 					   ".RData",
			 					   sep=""))) 
		rm(comTimes)
	}

	rm(glmnet1b_PAs)
	rm(tmp)
	rm(glmnet_boostr)
	gc()
	
	}
##########################################################################################
