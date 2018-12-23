##########################################################################################
# UNIVARIATE GENERALIZED LINEAR MODELS WITH LASSO or ELASTICNET PENALTY PREDICTION
##########################################################################################
require(glmnet)

BICglmnet <- function(fit) {
	tLL <- fit$nulldev - deviance(fit)
	k <- fit$df
	n <- fit$nobs
	bic <- log(n)*k - tLL
	return(bic)
}

##########################################################################################

for (j in 1:3) {

	load(file=file.path(FD2,set_no,paste0("glmnet1_",j,"_",dataN[sz],".RData")))

	nsp <- ncol(y_valid[[j]])
	nsites <- nrow(y_valid[[j]])

	minBIClambdas <- vector("list", nsp) 
	for (i in 1:length(glmnet1)) {
		if (!is.null(glmnet1[[i]])) {
			BICs <- BICglmnet(glmnet1[[i]])
			minBICs <- which(BICs==min(BICs))
			minBIClambdas[[i]] <- glmnet1[[i]]$lambda[minBICs]
		}
	}

	save(minBIClambdas, 
		 file = file.path(PD2, 
		 		set_no, 
		 		paste0("glmnet_minBIClambdas_", 
		 		j, 
		 		"_", 
		 		dataN[sz], 
		 		".RData")))
	
	glmnet1_probs <- vector("list", nsp) 
	for (i in 1:length(glmnet1)) {
		if (!is.null(glmnet1[[i]])) { 
			glmnet1_probs[[i]] <- predict(glmnet1[[i]],
									 newx = x_valid[[j]][,-1],
									 s = minBIClambdas[[i]],
									 type="response") 
		}
	}
	
# 	glmnet1_probs <- foreach(i=1:nsp)  %dopar% { tryCatch({ glmnet1_probs[[i]][,sample(1:ncol(glmnet1_probs[[i]]), 100)] },
# 	                                                       	error=function(e){cat("ERROR :",conditionMessage(e), "\n")}) }
	
	isNULL <- unlist(lapply(glmnet1_probs,is.null))
	save(isNULL, file = file.path(PD2,set_no,paste0("glmnet1_isNULL_",j,"_",dataN[sz],".RData")))

	if (sum(isNULL) != 0) {
		for (i in 1:sum(isNULL)) {
			glmnet1_probs[isNULL][i] <- list(matrix(mean(DD_t[[j]][isNULL][[i]][,1]), ncol = 1, nrow = nsites))
		}
	}

	glmnet1_PA <- array(NA, dim=list(nsites, nsp, REPs))
	for (n in 1:REPs) {
		glmnet1_PA[,,n] <- simplify2array( foreach(i=1:nsp)  %dopar% { rbinom(glmnet1_probs[[i]], 
																			  1, 
																			  glmnet1_probs[[i]]) } )
	}

	save(glmnet1_PA, 
		 file = file.path(PD2, 
		 		set_no, 
		 		paste("glmnet1_PAs_", 
		 		j, 
		 		"_", 
		 		dataN[sz], 
		 		".RData",sep="")))

	rm(glmnet1)
	rm(glmnet1_probs)
	rm(glmnet1_PA)
	gc()

}
##########################################################################################
