##########################################################################################
# UNIVARIATE GENERALIZED LINEAR MODELS WITH LASSO or ELASTICNET PENALTY
##########################################################################################

require(glmnet)

for (j in 1:3) {
  
	nsp <- length(DD_t[[j]])

	if (j==1) { sT<-Sys.time() }

	glmnet1 <- vector("list", nsp) 

	for (i in 1:nsp)  { 

		  glmnet1[[i]] <- tryCatch({ glmnet(y = y_train[[j]][,i], 
							                          x = x_train[[j]][,-1],
							                          family = "binomial",
							                          alpha = 1, 
							                          nlambda = 200, 
							                          standardize = FALSE, 
							                          intercept = TRUE)},
						                     error=function(e){cat("ERROR :",
						                     conditionMessage(e), "\n")}) 
						
						}
						
	if (j==1) {
		eT<-Sys.time()
		comTimes<-eT-sT
	}

	save(glmnet1, file=file.path(FD,
								 set_no,
								 paste("glmnet1_",
								 		j,
								 		"_",
								 		dataN[sz],
								 		".RData",
								 		sep="")
								 )
		 )
		 
	if (j==1) {
		save(comTimes, file=file.path(FD,
									  set_no,
									  paste("comTimes_GLMNET1_",
									  		dataN[sz],
									  		".RData",
									  		sep="")
									   )
			 )
	}
}

##########################################################################################
