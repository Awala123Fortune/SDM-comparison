##########################################################################################
# SPECIES ARCHETYPE MODELS PREDICTIONS
##########################################################################################

require(mvabund)
source(file.path(MD,"newSAM/coordinSAMsv2_SDF_FKCH_SDF.R"))

##########################################################################################

for (j in 1:3) {

	nsp <- ncol(y_valid[[j]])
	nsites <- nrow(y_valid[[j]])

	Xv <- x_valid[[j]][,-1]

	load(file=file.path(FD2,set_no,paste("sams1_",j,"_",dataN[sz],".RData",sep="")))

	sam1_PAs <- array(NA, dim=list(nsites,nsp,REPs))

	if (commSP & length(sams1) == 1) {
     print(sams1)	  
	   load(file=file.path("F:/FITS",set_no,paste("sams1_",j,"_",dataN[sz],".RData",sep="")))
	   common_sp <- read.table(file=file.path(DD, paste0("common_sp_d",j,"_",Sets[d],".csv")))

	   for (n in 1:REPs) {
	     sam1_preds <- predict.sams(psams=sams1, newX=Xv, family="binomial")
	     sam1_PAs[,,n] <- sam1_preds$predict.y[,common_sp[,1]]
	   }
	   
	} else {

	  for (n in 1:REPs) {
	    sam1_preds <- predict.sams(psams=sams1, newX=Xv, family="binomial")
	    sam1_PAs[,,n] <- sam1_preds$predict.y
	  }
	}  
	
	filebody <- paste0("sam1_PAs_", j, "_", dataN[sz])
	if (commSP) {
		filebody <- paste0(filebody, "_commSP")
	}		

	save(sam1_PAs, file=file.path(PD2, set_no, paste0(filebody, ".RData")))

	rm(sams1)
	rm(sam1_preds)
	rm(sam1_PAs)	
	gc()
	
	}
##########################################################################################
