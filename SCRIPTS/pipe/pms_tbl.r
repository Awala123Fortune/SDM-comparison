##########################################################################################
# full PM results table with features without any tranformations
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

ensmbles <- c(NA, 'all', 'top5')

TBL_PMS_ALL <- NA

for (e in 1:length(ENS)) {
	ensmblModels <- ENS[[e]]
	ensmbl <- ensmbles[[e]]
	#TBL_PMS_all<-NA

	for (sz in dszs) {

		filebody <- file.path(RDfinal, dataN[sz], "meta_analysis", "PMS")
		filebody <- appendFilebody(filebody,
									ensmblModels, 
									nmodels, 
									commSP, 
									MCMC2)
		load(file=paste0(filebody, ".RData"))

		noMod <- dim(PMS)[1]/(3*length(Sets))

		if ( !is.null(ensmblModels) ) {
			tblrep <- matrix(rep(c(paste("ENS", ensmbl, sep="_"),
								   "ensemble",
								   1*(colSums(feats[ENS[[e]],3:ncol(feats)])>0)),
								 each=(length(Sets)*3)),
							 nrow=length(Sets)*3)								 
			colnames(tblrep) <- colnames(feats)
			TBL<-cbind(tblrep,
					   dataN[sz],
					   rep(rep(c("i","e1","e2"), each=noMod), length(Sets)),
					   rep(Sets, each=(noMod*3)))
		} else {
			tblrep <- apply(feats, 2, rep, times=3*length(Sets))
			TBL <- cbind(tblrep, 
						 dataN[sz], 
						 rep(rep(c("i","e1","e2"),
								 each=noMod),
							 length(Sets)),
						 rep(Sets, each=(noMod*3)))
		}
		colnames(TBL)[(ncol(TBL)-2):ncol(TBL)] <- c("dataSize","predType","dataSet")
		TBL_PMS <- cbind(TBL, PMS)
		#TBL_PMS <- cbind(TBL, PMS, PRVthr)
		#colnames(TBL_PMS)[ncol(TBL_PMS)] <- "prevThr"
		
		#print(paste("Number of NAs",sum(is.na(TBL_PMS)),"for data size",dataN[sz]))
		#TBL_PMS_all<-rbind(TBL_PMS_all,TBL_PMS)			
		#TBL_PMS_all<-TBL_PMS_all[-1,]

		filebody <- file.path(RDfinal, dataN[sz], "meta_analysis", "finalTBLall")
		filebody <- appendFilebody(filebody,
									ensmblModels=NULL, 
									nmodels, 
									commSP, 
									MCMC2)
		save(TBL_PMS, file=paste0(filebody, ".RData"))
		TBL_PMS_ALL <- rbind(TBL_PMS_ALL, TBL_PMS)
	}
}
TBL_PMS_ALL <- TBL_PMS_ALL[-1,]
rownames(TBL_PMS_ALL) <- NULL
#if ( dim(TBL_PMS_ALL)[1] != (length(PRV)*2*length(Sets)*(length(mod_names)+2)*3) ){
#	stop("Wrong amount of rows in 'TBL_PMS_ALL'")
#}
#head(TBL_PMS_ALL)

filebody <- "TBL_PMS_ALL"
if (commSP) { filebody <- paste0(filebody, "_commSP") }
if (MCMC2) { filebody <- paste0(filebody, "_MCMC2") }

save(TBL_PMS_ALL, file=file.path(RDfinal,paste0(filebody,".RData")))
write.table(TBL_PMS_ALL,
			file=file.path(RDfinal,paste0(filebody,".csv")),
			sep=",",
			row.names=F,
			col.names=T)					
