##########################################################################################
# SPECIES RICHNESS AT SITE LEVEL
# resulting matrix: nsp, nsamples*nsites
##########################################################################################
require(abind)

ensmblModels <- ENS[[e]]

sp_rich_site <- list()

for (j in 1:3) {

	if ( !is.null(ensmblModels) ) {
		pred_names_tmp<-pred_names[ensmblModels]
		pred_comms_ensemble<-array(NA, dim=list(dim(y_valid[[j]])[1],
												dim(y_valid[[j]])[2],
												1))
	} else {
		pred_names_tmp<-pred_names
		spRichSite <- array(NA, dim=list(dim(y_valid[[j]])[1],
										 REPs,
										 nmodels))
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
			pred_comms_ensemble <- abind(pred_comms_ensemble,
										 pred_comms[,,predSamp])
		} else {
			spRichSite[,,m] <- apply(pred_comms, 3, rowSums, na.rm=T)
		}

		rm(pred_comms) 
		gc()   
	
	}	

	if ( !is.null(ensmblModels) ) {
		tmp <- pred_comms_ensemble[,,-1]
		spRichSite <- apply(tmp, 3, rowSums,na.rm=T)
		if ( ncol(spRichSite) > REPs ) {
			away <- sample(1:ncol(spRichSite), ncol(spRichSite)-REPs)
			spRichSite <- spRichSite[,-away]
			rm(away)
		}
		rm(pred_comms_ensemble)
		rm(tmp)
	}		

	sp_rich_site[[j]] <- spRichSite
	rm(spRichSite)
}

filebody <- file.path(RD2, Sets[d], "sp_rich_site_")
filebody <- appendFilebody(filebody,
						   ensmblModels, 
						   nmodels, 
						   commSP, 
						   MCMC2)
save(sp_rich_site, file=paste0(filebody, dataN[sz], ".RData"))

rm(sp_rich_site)   
gc()   

##########################################################################################
