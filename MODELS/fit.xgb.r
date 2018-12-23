##########################################################################################
# GRADIENT BOOSTING WITH XGBOOST
##########################################################################################

library(xgboost)

##########################################################################################

for (j in 1:3) {

	nsp <- ncol(y_train[[j]])

	if (j==1) { sT<-Sys.time() }
	
	xgb1 <- list()
	
	for (i in 1:nsp) {
		
		xgb1[[i]] <- xgboost(data = x_train[[j]][,-1], 
						  label = y_train[[j]][,i], 
						  nrounds = 1000, 
						  objective = "binary:logistic", 
						  verbose = 1, 
						  print_every_n = 100,
						  max.depth = 6, 
						  nthread = 2, 
						  eta = 1, 
						  booster = "gblinear")
	
	}
	if (j==1) {
		eT<-Sys.time()
		comTimes<-eT-sT
	}

	filebody <- paste("xgb1_",j,"_",dataN[sz],".RData",sep="")
	save(xgb1, file=file.path(FD, set_no, filebody))
	if (j==1) {
		ct_filebody <- paste("comTimes_XGB1_",dataN[sz],".RData",sep="")
		save(comTimes, file=file.path(FD,set_no,ct_filebody))
	}
}

##########################################################################################