##########################################################################################
# GENERALIZED ADDITIVE MODELS PREDICTIONS
##########################################################################################

require(mgcv)

##########################################################################################
modls <- c(1, "_spat1")

for (j in 1:3) {

	nsp <- length(DD_v[[j]])
	nsites <- nrow(DD_v[[j]][[1]])

	for (m in 1:2) {

		load(file=file.path(FD,
		                    set_no,
		                    paste0("gams",
		                    	   modls[m],
		                    	   "_",
		                    	   j,
		                    	   "_",
		                    	   dataN[sz],
		                    	   ".RData")))

		if (m==1) { 
			gams <- gams1
			isNULL <- unlist(lapply(gams, is.null))
		}
		if (m==2) { 
			gams <- gams_spat1
			isNA <- lapply(gams, is.na)
			isNA <- lapply(isNA, sum)		
			isNA <- unlist(lapply(isNA, as.logical))
			isNULL <- unlist(lapply(gams, is.null))
			isNULL <- as.logical(isNA + isNULL)
		}

		save(isNULL, 
		     file = file.path(PD2,
		                      set_no,
		                      paste0("gam",
		                    		 modls[m],
		                    		 "_isNULL_",
		                    		 j,
		                    		 "_",
		                    		 dataN[sz],
		                    		 ".RData")))
		
		gam_preds <- vector("list", nsp)

		for ( i in c(1:nsp)[!isNULL] ) {
			if (m==1) { 
				gam_fit <- gams[[i]]
			}
			if (m==2) { 
				gam_fit <- gams[[i]]$gam
			}
			gam_preds[[i]] <- predict(gam_fit,
									  newdata=DD_v[[j]][[i]],
									  type="link")							
		}
		for ( i in c(1:nsp)[isNULL] ) {
			gam_preds[[i]] <- rep(mean(DD_t[[j]][[i]][,1]),
								  times=nsites)
		}
		gam_preds <- simplify2array(gam_preds)

		gam_PAs <- array(NA, dim=list(nsites, nsp, REPs))
		for (n in 1:REPs) {
			gam_PAs[,!isNULL,n] <- (gam_preds[,!isNULL]+unlist(rnorm(gam_preds[,!isNULL],mean=0,sd=1))>0)*1
			if (m==1) { 
				gam_PAs[,isNULL,n] <- rbinom(gam_preds[,isNULL],1,gam_preds[,isNULL])
			}
			if (m==2) { 
				gam_PAs[,isNULL,n] <- gam_PAs_m1[,isNULL,n]
			}
		}

		rm(gams)
		rm(gam_preds)

		save(gam_PAs, file=file.path(PD2,
		                             set_no,
		                             paste0("gam",
		                             		modls[m],
		                             		"_PAs_",
		                             		j,
		                             		"_",
		                             		dataN[sz],
		                             		".RData")))
		if (m==1) { 
			gam_PAs_m1 <- gam_PAs
		}
		rm(gam_PAs)
		gc()

	}
}	

##########################################################################################
