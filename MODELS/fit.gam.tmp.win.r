# GAMs FOR THE BAKEOFF DATA
##########################################################################################
rm(list = ls(all=TRUE)); gc()	# clear workspace

pth <- "D:/HY-data/NORBERG/OneDrive - University of Helsinki" 

WD <- file.path(pth, "bakeoff", "pipeline")
setwd(WD)										# set working directory to the pipeline folder
SD <- file.path(WD, "SCRIPTS")
SETT <- file.path(SD, "settings.r")				# path to settings
source(file.path(SD,"pipe", "get_os.r"))		# identify your OS
source(file.path(SD,"pipe", "parall.r"))		# and define settings for parallel computing

# model fitting & predictions
##########################################################################################

MCMC2 <- FALSE
commSP <- FALSE
intXs <- FALSE

source(SETT)

sz <- 3
d <- 5	
set_no <- Sets[d]
source(readdata)

##########################################################################################

#FD4 <- file.path(WD,"FITS4")

##########################################################################################
	
require(mgcv)
require(nlme)

BS <- "cs"

if (set_no=="birds" | set_no=="butterfly" | set_no=="plant") { 
	form <- as.formula(sp~s(V1, bs=BS)+s(V2, bs=BS)+s(V3, bs=BS)+s(V4, bs=BS)+s(V5, bs=BS))
}
if (set_no=="trees") { 
	form <- as.formula(sp~s(V1, bs=BS)+s(V2, bs=BS)+s(V3, bs=BS))
}
if (set_no=="vegetation") { 
	form <- as.formula(sp~s(V1, bs=BS)+s(V2, bs=BS)+s(V3, bs=BS)+s(V4, bs=BS))
}

if (intXs) {
	if (set_no=="birds" | set_no=="butterfly" | set_no=="plant") { 
		form <- as.formula(sp~s(V1, bs=BS)+s(V2, bs=BS)+s(V3, bs=BS)+s(V4, bs=BS)+s(V5, bs=BS)+
			s(V1, by=V2, bs=BS)+s(V1, by=V3, bs=BS)+s(V1, by=V4, bs=BS)+s(V1, by=V5, bs=BS)+
			s(V2, by=V1, bs=BS)+s(V2, by=V3, bs=BS)+s(V2, by=V4, bs=BS)+s(V2, by=V5, bs=BS)+
			s(V3, by=V1, bs=BS)+s(V3, by=V2, bs=BS)+s(V3, by=V4, bs=BS)+s(V3, by=V5, bs=BS)+
			s(V4, by=V1, bs=)+s(V4, by=V2, bs=BS)+s(V4, by=V3, bs=BS)+s(V4, by=V5, bs=BS)+
			s(V5, by=V1, bs=BS)+s(V5, by=V2, bs=BS)+s(V5, by=V3, bs=BS)+s(V5, by=V4, bs=BS))

	}
	if (set_no=="trees") { 
		form <- as.formula(sp~s(V1, bs=BS)+s(V2, bs=BS)+s(V3, bs=BS) + 
			s(V1, by=V2, bs=BS)+s(V1, by=V3, bs=BS)+
			s(V2, by=V1, bs=BS)+s(V2, by=V3, bs=BS)+
			s(V3, by=V1, bs=BS)+s(V3, by=V2, bs=BS))

	}
	if (set_no=="vegetation") { 
		form <- as.formula(sp~s(V1, bs=BS)+s(V2, bs=BS)+s(V3, bs=BS)+s(V4, bs=BS)+
			s(V1, by=V2, bs=BS)+s(V1, by=V3, bs=BS)+s(V1, by=V4, bs=BS)+
			s(V2, by=V1, bs=BS)+s(V2, by=V3, bs=BS)+s(V2, by=V4, bs=BS)+
			s(V3, by=V1, bs=BS)+s(V3, by=V2, bs=BS)+s(V3, by=V4, bs=BS)+
			s(V4, by=V1, bs=BS)+s(V4, by=V2, bs=BS)+s(V4, by=V3, bs=BS))
	}
}

##########################################################################################

for (j in 1:3) {

	nsp <- length(DD_t[[j]])

	if (j==1) { sT<-Sys.time() }

# 	gams1	<-	vector("list", nsp) 
# 	for	(i in 1:nsp) {	
# 		gams1[[i]] <- tryCatch({gam(form,
# 									family=binomial(link="probit"), 
# 									data=DD_t[[j]][[i]])},
# 						error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
# 	}

	gams1	<-	foreach	(i=1:nsp, .packages='mgcv') %dopar% { tryCatch({gam(form, 
																			family=binomial(link="probit"), 
																			data=DD_t[[j]][[i]])},
						error=function(e){cat("ERROR :",conditionMessage(e), "\n")}) }

	if (j==1) {
		eT<-Sys.time()
		comTimes<-eT-sT
		}

	if (intXs) {
		filebody <- paste("gams1_intXs_",j,"_",dataN[sz],".RData",sep="")
	} else {
		filebody <- paste("gams1_",j,"_",dataN[sz],".RData",sep="")	
	}
	save(gams1, file=file.path(FD2,set_no,filebody))

	if (j==1) {
		if (intXs) {
			ct_filebody <- paste("comTimes_GAM_intXs_",dataN[sz],".RData",sep="")
		} else {
			ct_filebody <- paste("comTimes_GAM1_",dataN[sz],".RData",sep="")
		}
		save(comTimes, file=file.path(FD2,set_no,ct_filebody))
		rm(comTimes)
	}
	
	if (j==1) { sT<-Sys.time() }

# 	gams_spat1	<-	vector("list", nsp) 
# 	for	(i in 1:nsp) {	
# 
# 		tmp				<- tryCatch({ gamm(form,
# 										   correlation=corExp(form=~Rand1+Rand2), 
# 										   family=binomial(link="probit"), 
# 										   data=DD_t[[j]][[i]]) },
# 										   error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
# 		if ( !is.null(tmp) ) { 
# 			gams_spat1[[i]]  <- tmp
# 		} else {
# 			gams_spat1[[i]] <- NA
# 		}
# 	}

	gams_spat1	<-	foreach	(i=1:nsp, .packages='mgcv') %dopar% { tryCatch({gamm(form, 
									 										    correlation=corExp(form=~Rand1+Rand2), 
																				family=binomial(link="probit"), 
																				data=DD_t[[j]][[i]])},
						error=function(e){cat("ERROR :",conditionMessage(e), "\n")}) }

	if (j==1) {
		eT<-Sys.time()
		comTimes<-eT-sT
	}

	if (intXs) {
		filebody <- paste("gams_spat1_intXs_",j,"_",dataN[sz],".RData",sep="")
	} else {
		filebody <- paste("gams_spat1_",j,"_",dataN[sz],".RData",sep="")
	}
	save(gams_spat1, file=file.path(FD2,set_no,filebody))

	if (j==1) {
		if (intXs) {
			ct_filebody <- paste("comTimes_GAMspat1_intXs_",dataN[sz],".RData",sep="")
		} else {
			ct_filebody <- paste("comTimes_GAMspat1_",dataN[sz],".RData",sep="")
		}
		save(comTimes, file=file.path(FD2,set_no,ct_filebody))
		rm(comTimes)
	}
	
	rm(gams1)
	rm(gams_spat1)

}
##########################################################################################