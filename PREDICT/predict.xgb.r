##########################################################################################
# GRADIENT BOOSTING WITH XGBOOST
##########################################################################################

require(xgboost)

##########################################################################################

for (j in 1:3) {

	load(file = file.path(FD2, 
						  set_no, 
						  paste("xgb1_",j,"_",dataN[sz],".RData",sep="")))

	nsp <- ncol(y_train[[j]])
	
	xgb1_PAs <- array(NA, dim=list(nrow(x_valid[[j]]), nsp, REPs)) 

	for (n in 1:REPs) {
		for (i in 1:nsp) {
			xgb1_preds <- NULL
			xgb1_preds <- predict(xgb1[[i]], newdata = x_valid[[j]][,-1])  
			xgb1_PAs[,i,n] <- rbinom(xgb1_preds, 1, xgb1_preds)
		}
	}

	save(xgb1_PAs, file = file.path(
		 PD2,
    	 set_no,
    	 paste("xgb1_PAs_", j, "_", dataN[sz], ".RData", sep = "")
  		 ))
    
	rm(xgb1)
	rm(xgb1_preds)
	rm(xgb1_PAs)
	gc()
}

##########################################################################################
