##########################################################################################
# MODIFY COMMON SPECIES PREDICTIONS FOR NOT-JOINT MODELS
##########################################################################################

rm(list=ls()[!(ls() %in% c("OS",
						   "pth",
						   "SETT",
						   "ENS",
						   "PRVthr",
						   "MCMC2",
						   "commSP",
						   "intXs",
						   "dszs"))]) 
gc(); source(SETT); setwd(WD)

source(file.path(SD, "pipe", "appendFilebody.r"))

for (sz in dszs) {

	for (d in 1:length(Sets)) {
		set_no <- Sets[d]; source(readdata)

		for (j in 1:3) {

			sps <- which((colSums(y_train[[j]])/nrow(y_train[[j]])) >= PRVthr)	
	
			for (m in 1:length(pred_names_notJoint)) {

    			model <- local({ load(file.path(PD2, 
	    					   	 Sets[d],
	    					   	 paste0(pred_names_notJoint[[m]],
	    					   		 	j,
	    				   			  	"_",
	    				   			  	dataN[sz],
	    				   		  		".RData")))
    				 	stopifnot(length(ls())==1)
    			 	 	environment()[[ls()]]
	    		})

				pred_comms <- simplify2array(model)
				pred_comms <- as.array(pred_comms)
				if ( any(is(pred_comms) == "simple_sparse_array") ) {
					pred_comms<- array(pred_comms$v, dim=pred_comms$dim)
				}
				pred_comms_commSP <- pred_comms[,sps,]
				filebody <- paste0(pred_names_notJoint[[m]],j,"_",dataN[sz],"_commSP")
				save(pred_comms_commSP, file=file.path(PD2, Sets[d], paste0(filebody, ".RData")))		
			}
		}				
	}
}

