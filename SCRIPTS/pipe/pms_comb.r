##########################################################################################
# COMBINE PERFORMANCE MEASURES
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

for (e in 1:length(ENS)) {
	ensmblModels <- ENS[[e]]

	for (sz in c(1,3)) {
		PMS<-NA
		PMs<-list()
		for (d in 1:length(Sets)) {
			source(SETT); set_no <- Sets[d]; source(readdata)	
			##########################################################################
			# expctME
			filebody <- file.path(RDfinal, dataN[sz], "expctME_")
			filebody <- appendFilebody(filebody,
										ensmblModels, 
										nmodels, 
										commSP, 
										MCMC2)
			load(file=paste0(filebody, Sets[d], ".RData"))
			PMs[[1]] <- as.vector(expctME)
			names(PMs)[1] <- "accuracy1"

			# AUCs
			filebody <- file.path(RDfinal, dataN[sz], "AUCs_")
			filebody <- appendFilebody(filebody,
										ensmblModels, 
										nmodels, 
										commSP, 
										MCMC2)
			load(file=paste0(filebody, Sets[d], ".RData"))
			PMs[[2]] <- as.vector(AUCs)
			names(PMs)[2] <- "discrimination1"

			# sqrt_pr
			filebody<-file.path(RDfinal,dataN[sz],"sqrt_pr_")
			filebody <- appendFilebody(filebody,
										ensmblModels, 
										nmodels, 
										commSP, 
										MCMC2)
			load(file=paste(filebody,Sets[d],".RData",sep=""))
			PMs[[3]] <- as.vector(sqrt_pr)
			names(PMs)[3] <- "sharpness1"

			# probBinRMSE
			filebody<-file.path(RDfinal,dataN[sz],"probBinRMSE_")
			filebody <- appendFilebody(filebody,
										ensmblModels, 
										nmodels, 
										commSP, 
										MCMC2)
			load(file=paste(filebody,Sets[d],".RData",sep=""))
			PMs[[4]] <- as.vector(probBinRMSE)
			names(PMs)[4] <- "calibration1"

			# spRichSiteRMSE, BetaRMSE
			filebody1<-file.path(RDfinal, dataN[sz], "spRichSiteRMSE_")
			filebody1 <- appendFilebody(filebody1,
										ensmblModels, 
										nmodels, 
										commSP, 
										MCMC2)
			load(file=paste0(filebody1, Sets[d], ".RData"))
			filebody2<-file.path(RDfinal, dataN[sz], "BetaRMSE_")
			filebody2 <- appendFilebody(filebody2,
										ensmblModels, 
										nmodels, 
										commSP, 
										MCMC2)
			load(file=paste0(filebody2, Sets[d], ".RData"))
			PMs[[5]] <- as.vector(spRichSiteRMSE)
			names(PMs)[5] <- "accuracy2site"
			for (b in 1:3) {
				PMs[[(5+b)]] <- as.vector(BetaRMSE[[b]])
				names(PMs)[(5+b)] <- paste0("accuracy3beta", b)
			}

			# spRichSiteSpear, betaIndSpear
			filebody1<-file.path(RDfinal,dataN[sz],"spRichSiteSpear_")
			filebody1 <- appendFilebody(filebody1,
										ensmblModels, 
										nmodels, 
										commSP, 
										MCMC2)
			load(file=paste0(filebody1, Sets[d], ".RData"))
			filebody2<-file.path(RDfinal,dataN[sz],"betaIndSpear_")
			filebody2 <- appendFilebody(filebody2,
										ensmblModels, 
										nmodels, 
										commSP, 
										MCMC2)
			load(file=paste0(filebody2, Sets[d], ".RData"))
			if ( !is.null(ensmblModels) ) {
				tmp1 <- colMeans(spRichSiteSpear, na.rm=T)
				tmp3 <- lapply(betaIndSpear, colMeans, na.rm=T)
			} else {
				tmp1 <- apply(spRichSiteSpear, 3, rowMeans, na.rm=T)
				tmp3 <- list()
				for (b in 1:3) {
					tmp3[[b]] <- apply(betaIndSpear[[b]], 3, rowMeans, na.rm=T)
				}
			}
			PMs[[9]] <- as.vector(tmp1)
			names(PMs)[9] <- "discrimination2site"
			for (b in 1:3) {
				PMs[[(9+b)]] <- as.vector(tmp3[[b]])
				names(PMs)[(9+b)] <- paste0("discrimination3beta", b)
			}
			rm(tmp1)
			rm(tmp3)
			gc()

			# spRichSiteSD, betaIndSD
			filebody1<-file.path(RDfinal, dataN[sz], "spRichSiteSD_")
			filebody1 <- appendFilebody(filebody1,
										ensmblModels, 
										nmodels, 
										commSP, 
										MCMC2)
			load(file=paste0(filebody1, Sets[d], ".RData"))
			filebody2<-file.path(RDfinal, dataN[sz], "betaIndSD_")
			filebody2 <- appendFilebody(filebody2,
										ensmblModels, 
										nmodels, 
										commSP, 
										MCMC2)
			load(file=paste0(filebody2, Sets[d], ".RData"))
			if ( !is.null(ensmblModels) ) {
				tmp1<-colMeans(spRichSiteSD)
				tmp3<-lapply(betaIndSD,colMeans)
			} else {
				tmp1<-apply(spRichSiteSD,3,rowMeans)
				tmp3<-list()
				for (b in 1:3) {
					tmp3[[b]]<-apply(betaIndSD[[b]],3,rowMeans)
				}
			}
			PMs[[13]]<-as.vector(tmp1)
			names(PMs)[13]<-"sharpness2site"
			for (b in 1:3) {
				PMs[[(13+b)]]<-as.vector(tmp3[[b]])
				names(PMs)[(13+b)]<-paste("sharpness3beta",b,sep="")
			}
			rm(tmp1)
			rm(tmp3)
			gc()

			# f50_sprichSite, f50_Betas
			filebody1<-file.path(RDfinal, dataN[sz], "f50_sprichSite_")
			filebody1 <- appendFilebody(filebody1,
										ensmblModels, 
										nmodels, 
										commSP, 
										MCMC2)
			load(file=paste0(filebody1, Sets[d], ".RData"))
			filebody2<-file.path(RDfinal,dataN[sz],"f50_Betas_")
			filebody2 <- appendFilebody(filebody2,
										ensmblModels, 
										nmodels, 
										commSP, 
										MCMC2)
			load(file=paste0(filebody2,Sets[d],".RData"))
			tmp1 <- abs(0.5-f50_sprichSite)
			tmp3 <- list()
			for (b in 1:3) {
				tmp3[[b]] <- abs(0.5-f50_Betas[[b]])
			}
			PMs[[17]] <- as.vector(tmp1)
			names(PMs)[17] <- "calibration2site"
			for (b in 1:3) {
				PMs[[(17+b)]] <- as.vector(tmp3[[b]])
				names(PMs)[(17+b)] <- paste0("calibration3beta",b)
			}
			rm(tmp1)
			rm(tmp3)
			gc()

			##########################################################################

			pms<-simplify2array(PMs)
			PMS<-rbind(PMS,pms)
			
			rm(pms)
			rm(f50_sprichSite)
			rm(f50_Betas)
			rm(spRichSiteSD)
			rm(betaIndSD)
			rm(betaIndSpear)
			rm(spRichSiteSpear)
			rm(spRichSiteRMSE)
			rm(BetaRMSE)
			rm(probBinRMSE)
			rm(sqrt_pr)
			rm(AUCs)
			rm(expctME)
			gc()
		}
		PMS<-PMS[-1,]

		filebody <- file.path(RDfinal, dataN[sz], "meta_analysis", "PMS")
		filebody <- appendFilebody(filebody,
						ensmblModels, 
						nmodels, 
						commSP, 
						MCMC2)

		save(PMS, file=paste0(filebody, ".RData"))
	}
}

