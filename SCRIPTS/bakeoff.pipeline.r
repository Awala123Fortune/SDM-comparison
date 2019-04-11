#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# BAKEOFF SDM COMPARISON PIPELINE
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 1 preliminaries
#-----------------------------------------------------------------------------------------
rm(list = ls(all = TRUE)); gc()	# clear workspace

pth <- "..." 	# write here the path to the location of the 'bakeoff' folder

WD <- file.path(pth, "bakeoff", "pipeline") # define your working directory
setwd(WD)									# set working directory to the pipeline folder
SD <- file.path(WD, "SCRIPTS_rev2")              # define path to pipeline scripts
SETT <- file.path(SD, "settings.r")			# path to settings

source(file.path(SD,"pipe", "get_os.r"))	# identify your OS
OS <- get_os()
source(file.path(SD,"pipe", "pkgs.r"))	# install required packages, 
source(file.path(SD,"pipe", "dirs.r"))	# create directories (if don't exist),
source(file.path(SD,"pipe", "parall.r"))	# and define settings for parallel computing

# 2 model fitting & predictions
#-----------------------------------------------------------------------------------------
MCMC2 <- FALSE
commSP <- FALSE
intXs <- FALSE

source(SETT)		# run settings

for (sz in c(1, 3)) {
    for (d in 1:length(Sets)) {

        set_no <- Sets[d]
        source(readdata)
        source(fitmodels)
        source(makepreds)
        
    }	
}

# 3 modify common species predictions for stacked models
#-----------------------------------------------------------------------------------------
rm(list=ls()[!(ls() %in% c("OS", "pth", "WD", "SETT"))]) 
gc()
setwd(WD)

MCMC2 <- FALSE
commSP <- TRUE

source(SETT)
library(sdmCom)

source(file.path(SD, "mod_pred_comm_sp.r"))

for (sz in c(1, 3)) {
    for (d in 1:length(Sets)) {
        set_no <- Sets[d]
        source(readdata)

        for (j in 1:3) {
            common_sp <- read.table(file = file.path(DD,
                                                     paste0("common_sp_d", 
                                                            j, 
                                                            "_", 
                                                            Sets[d], 
                                                            ".csv")))            
            for (i in 1:length(pred_list_comsp)) {
                pred_name <- paste0(pred_list_comsp[[i]], 
                                    paste(j, 
                                          dataN[sz],
                                          sep = "_"))
                pred_name_o <- pred_name
                if (MCMC2) {
    				pred_name <- paste0(pred_name, "_MCMC2")
				}

                pred_comms_commSP <- mod_pred_comm_sp(directory = file.path(PD2, set_no),
                                                      pred_name = paste0(pred_name,".RData"), 
                                                      sps = t(common_sp))

				filebody <- paste0(pred_name_o, "_commSP")
				if (MCMC2) {
    				filebody <- paste0(filebody, "_MCMC2")
				}
				save(pred_comms_commSP, 
				     file = file.path(PD2, Sets[d], paste0(filebody, ".RData")))		
            }
        }
    }
}

# 4.1 calculate performance measures (PM)
#-----------------------------------------------------------------------------------------
rm(list=ls()[!(ls() %in% c("OS", "pth", "WD", "SETT"))]) 
gc()
setwd(WD)

MCMC2 <- FALSE
commSP <- TRUE

source(SETT)
library(sdmCom)
source(file.path(SD, "list_preds.r"))

ens <- list( 'ALL' = 'all',
             'BEST5' = list('HMSC3'='all', 
                            'GLM5'='all', 
                            'MISTN1'='all', 
                            'GNN1'='all', 
                            'MARS1'='all') )
predtypes <- c("interpol", "extrapol", "extrapol2")
NsitePairs <- 300
Nsamples <- 100

pms_res <- NA
for (sz in c(1, 3)) {
    dsz <- dataN[sz]

    for (d in 1:length(Sets)) {
        set_no <- Sets[d]
        source(readdata)

        for (j in 1:3) {
        
            pred_list <- vector("list", length(mod_names))
            names(pred_list) <- mod_names

            for (i in 1:length(pred_list)) {
                pred_list[[i]] <- vector("list", 1)
                tmp <- paste0(pred_names[[i]], 
                              paste(j, dsz, sep = "_"))
                if (commSP) {
                    tmp <- paste0(tmp, "_commSP")
                }
                if (MCMC2) {
                    tmp <- paste0(tmp, "_MCMC2")
                }
                names(pred_list[[i]]) <- tmp
            }

            preds <- list()
            preds$predictions <- list_preds(directory = file.path(PD2, set_no), 
                                            pred_list = pred_list)
            mod_preds <- modify_predictions(predictions = preds, 
                                            yvalid = y_valid[[j]],
                                            n_of_site_pairs = NsitePairs)
            ens_preds <- create_ensembles(ensembles = ens,
                                          predictions = preds,
                                          nsamples = Nsamples)
            mod_ens_preds <- modify_predictions(predictions = ens_preds, 
                                                yvalid = y_valid[[j]],
                                                n_of_site_pairs = NsitePairs)
            tmp <- cbind(predtypes[j],
                         dsz,
                         set_no,
                         calculate_pms(modified_predictions = mod_preds))           
            tmp_ens <- cbind(predtypes[j],
                         dsz,
                         set_no,
                         calculate_pms(modified_predictions = mod_ens_preds))           
            pms_res <- rbind(pms_res,
                             tmp,
                             tmp_ens)
        }
    }
}
head(pms_res)
dim(pms_res)
pms_res_o <- pms_res[-1,]
pms_res <- pms_res_o
pms_res[, c(1, 3:5)] <- apply(pms_res[, c(1, 3:5)], 2, as.character)
pms_res$modelling.framework[which(pms_res_o$modelling.framework=="ENS" & pms_res_o$model.variant=="ALL")] <- "ENS_all"
pms_res$modelling.framework[which(pms_res_o$modelling.framework=="ENS" & pms_res_o$model.variant=="BEST5")] <- "ENS_top5"

filebody <- "pms_res"
if (commSP) {
    filebody <- paste0(filebody, "_commSP")
}
if (MCMC2) {
    filebody <- paste0(filebody, "_MCMC2")
}
save(pms_res, file = file.path(RDfinal, paste0(filebody,".RData")))


# 4.2 combine PM result tables and model features
#-----------------------------------------------------------------------------------------
rm(list = ls()[!(ls() %in% c("OS", "pth", "WD", "SETT"))]) 
gc()
setwd(WD)

commSP <- FALSE
source(SETT)

filebody <- "pms_res"
load(file = file.path(RDfinal, "pms_res.RData"))
pms_res_allsp <- pms_res
rm(pms_res)
load(file = file.path(RDfinal, "pms_res_commSP.RData"))
pms_res_commsp <- pms_res
rm(pms_res)
pms_res_allsp <- cbind(pms_res_allsp, 0)
colnames(pms_res_allsp)[ncol(pms_res_allsp)] <- "prev_threshold"
pms_res_commsp <- cbind(pms_res_commsp, 0.1)
colnames(pms_res_commsp)[ncol(pms_res_commsp)] <- "prev_threshold"
pms_res_comb <- rbind(pms_res_allsp, pms_res_commsp)
feats <- read.csv2(file.path(DD, "feats.csv"), header = TRUE)
head(pms_res_comb)
sum(is.na(pms_res_comb))
sum(is.nan(unlist(pms_res_comb)))

pms_res_tbl <- NA
for (m in 1:nrow(feats)) {
    tmp <- cbind(feats[m,], 
                 pms_res_comb[which(pms_res_comb$modelling.framework==feats$Abbreviation[m]),])
    pms_res_tbl <- rbind(pms_res_tbl, tmp)
}
pms_res_tbl <- pms_res_tbl[-1,]
head(pms_res_tbl)

pms_res_tbl <- pms_res_tbl[,-c(14:15)]
colnames(pms_res_tbl)[which(colnames(pms_res_tbl)=="predtypes[j]")] <- "predType"
colnames(pms_res_tbl)[which(colnames(pms_res_tbl)=="dsz")] <- "dataSize"
colnames(pms_res_tbl)[which(colnames(pms_res_tbl)=="set_no")] <- "dataSet"

pms_res_tbl$predType[which(pms_res_tbl$predType=="interpol")] <- "i"
pms_res_tbl$predType[which(pms_res_tbl$predType=="extrapol")] <- "e"
pms_res_tbl$predType[which(pms_res_tbl$predType=="extrapol2")] <- "e2"
pms_res_tbl <- pms_res_tbl[,c(1:10, 12, 11, 13, 14:ncol(pms_res_tbl))]

pms_res_tbl_names <- colnames(pms_res_tbl)
pms_res_tbl_names[which(pms_res_tbl_names=="accuracy_expected_me")] <- "accuracy1"
pms_res_tbl_names[which(pms_res_tbl_names=="discrimination_auc")] <- "discrimination1"
pms_res_tbl_names[which(pms_res_tbl_names=="calibration_prob_bin_mse")] <- "calibration1"
pms_res_tbl_names[which(pms_res_tbl_names=="precision_sqrt_probs")] <- "precision1"
pms_res_tbl_names[which(pms_res_tbl_names=="sp_rich_rmse")] <- "accuracy2site"
pms_res_tbl_names[which(pms_res_tbl_names=="beta_sim_rmse")] <- "accuracy3beta1"
pms_res_tbl_names[which(pms_res_tbl_names=="beta_sne_rmse")] <- "accuracy3beta2"
pms_res_tbl_names[which(pms_res_tbl_names=="beta_sor_rmse")] <- "accuracy3beta3"
pms_res_tbl_names[which(pms_res_tbl_names=="sp_rich_spear")] <- "discrimination2site"
pms_res_tbl_names[which(pms_res_tbl_names=="beta_sim_spear")] <- "discrimination3beta1"
pms_res_tbl_names[which(pms_res_tbl_names=="beta_sne_spear")] <- "discrimination3beta2"
pms_res_tbl_names[which(pms_res_tbl_names=="beta_sor_spear")] <- "discrimination3beta3"
pms_res_tbl_names[which(pms_res_tbl_names=="sp_rich_predint")] <- "calibration2site"
pms_res_tbl_names[which(pms_res_tbl_names=="beta_sim_predint")] <- "calibration3beta1"
pms_res_tbl_names[which(pms_res_tbl_names=="beta_sne_predint")] <- "calibration3beta2"
pms_res_tbl_names[which(pms_res_tbl_names=="beta_sor_predint")] <- "calibration3beta3"
pms_res_tbl_names[which(pms_res_tbl_names=="sp_rich_sd")] <- "precision2site"
pms_res_tbl_names[which(pms_res_tbl_names=="beta_sim_sd")] <- "precision3beta1"
pms_res_tbl_names[which(pms_res_tbl_names=="beta_sne_sd")] <- "precision3beta2"
pms_res_tbl_names[which(pms_res_tbl_names=="beta_sor_sd")] <- "precision3beta3"
cbind(pms_res_tbl_names, colnames(pms_res_tbl))
colnames(pms_res_tbl) <- pms_res_tbl_names

save(pms_res_tbl, file = file.path(RDfinal, "pms_res_tbl.RData"))
write.table(pms_res_tbl, 
			file = file.path(RDfinal, "pms_res_tbl.csv"), 
			sep = ",", 
			row.names = FALSE,
            col.names = TRUE)


# 5 check convergences
#-----------------------------------------------------------------------------------------
rm(list = ls()[!(ls() %in% c("OS", "pth", "WD", "SETT"))]) 
gc()
setwd(WD)

commSP <- FALSE
source(SETT)
library(sdmCom)
source(file.path(SD, "list_preds.r"))

predtypes <- c("interpol", "extrapol", "extrapol2")

covergences_res <- matrix(NA, ncol = 5)
for (sz in c(1, 3)) {
    dsz <- dataN[sz]

    for (d in 1:length(Sets)) {
        set_no <- Sets[d]
        source(readdata)

        for (j in 1:3) {
            pred_list <- vector("list", length(mod_names_bayes))
            names(pred_list) <- mod_names_bayes
            pred_list_mcmc2 <- pred_list
            
            for (i in 1:length(pred_list)) {
                pred_list[[i]] <- vector("list", 1)
                tmp <- paste0(pred_names_bayes[[i]], 
                              paste(j, dsz, sep = "_"))
                pred_list_mcmc2[[i]] <- vector("list", 1)
                if (commSP) {
                    tmp <- paste0(tmp, "_commSP")
                }
                names(pred_list[[i]]) <- tmp
                names(pred_list_mcmc2[[i]]) <- paste0(tmp, "_MCMC2")
            }

            preds <- list()
            preds$predictions <- list_preds(directory = file.path(PD2, set_no), 
                                            pred_list = pred_list)
            mod_preds <- modify_predictions(predictions = preds, 
                                            yvalid = y_valid[[j]],
                                            values = "probabilities")
            occ_probs <- mod_preds$occurrence_probabilities

            preds_mcmc2 <- list()
            preds_mcmc2$predictions <- list_preds(directory = file.path(PD2, set_no), 
                                                  pred_list = pred_list_mcmc2)
            mod_preds_mcmc2 <- modify_predictions(predictions = preds_mcmc2, 
                                                  yvalid = y_valid[[j]],
                                                  values = "probabilities")
            occ_probs_mcmc2 <- mod_preds_mcmc2$occurrence_probabilities

            
            convergences <- matrix(NA, 
                                   ncol = length(occ_probs), 
                                   nrow = ncol(occ_probs[[i]][[1]]))
            colnames(convergences) <- names(occ_probs)
            colnames(convergences) <- names(occ_probs)
            for (i in 1:length(occ_probs)) {
                for (sp in 1:ncol(occ_probs[[i]][[1]])) {
                    convergences[sp,i] <- cor(occ_probs[[i]][[1]][,sp], 
                                              occ_probs_mcmc2[[i]][[1]][,sp], 
                                              method = "spearman")
                }
            }

            if ( sum(is.na(convergences)) > 0 ) {
                print(paste("Number of NAs in correlations for", 
                            Sets[d], 
                            predtypes[j], 
                            "data size",
                            dataN[sz],
                            "was", 
                            sum(is.na(convergences))))
            }
            tmp <- colMeans(convergences, na.rm = TRUE)
            covergences_res <- rbind(covergences_res, cbind(names(tmp), 
                                                            matrix(tmp, ncol = 1),
                                                            set_no,
                                                            predtypes[j],
                                                            dsz))            
        }
    }
}
covergences_res <- covergences_res[-1,]
colnames(covergences_res) <- c("model",
                               "correlation",
                               "taxon",
                               "data_type",
                               "data_size")

rownames(covergences_res) <- NULL
covergences_res <- data.frame(covergences_res)
covergences_res[,c(2,5)] <- apply(covergences_res[,c(2,5)], 2, as.numeric)
covergences_res[,-c(2,5)] <- apply(covergences_res[,-c(2,5)], 2, as.character)

filebody <- "covergences_res"
if (commSP) {
    filebody <- paste0(filebody, "_commSP")
}
save(covergences_res, file = file.path(RDfinal, paste0(filebody,".RData")))
write.table(covergences_res, 
			file = file.path(RDfinal, "convergences.csv"), 
			sep = ",", 
			row.names = FALSE,
            col.names = TRUE)

# 6 plots
#-----------------------------------------------------------------------------------------

# 6.1 plot performance measures
#-----------------------------------------------------------------------------------------
rm(list = ls()[!(ls() %in% c("OS", "pth", "WD", "SETT"))]) 
gc()
setwd(WD)

commSP <- FALSE
source(SETT)

filebody <- "pms_res"
if (commSP) {
    filebody <- paste0(filebody, "_commSP")
}
load(file = file.path(RDfinal, paste0(filebody, ".RData")))
resTBL <- data.frame(pms_res)
head(resTBL)

pms <- colnames(resTBL[,which(colnames(resTBL)=="accuracy_expected_me"):(ncol(resTBL))])
pms_ls <- as.list(pms)
names(pms_ls)[which(pms_ls=="accuracy_expected_me")] <- "PM 1 a"
names(pms_ls)[which(pms_ls=="discrimination_auc")] <- "PM 1 b"
names(pms_ls)[which(pms_ls=="calibration_prob_bin_mse")] <- "PM 1 c"
names(pms_ls)[which(pms_ls=="precision_sqrt_probs")] <- "PM 1 d"
names(pms_ls)[which(pms_ls=="sp_rich_rmse")] <- "PM 2 a"
names(pms_ls)[which(pms_ls=="beta_sim_rmse")] <- "PM 3sim a"
names(pms_ls)[which(pms_ls=="beta_sne_rmse")] <- "PM 3nest a"
names(pms_ls)[which(pms_ls=="beta_sor_rmse")] <- "PM 3sor a"
names(pms_ls)[which(pms_ls=="sp_rich_spear")] <- "PM 2 b"
names(pms_ls)[which(pms_ls=="beta_sim_spear")] <- "PM 3sim b"
names(pms_ls)[which(pms_ls=="beta_sne_spear")] <- "PM 3nest b"
names(pms_ls)[which(pms_ls=="beta_sor_spear")] <- "PM 3sor b"
names(pms_ls)[which(pms_ls=="sp_rich_predint")] <- "PM 2 c"
names(pms_ls)[which(pms_ls=="beta_sim_predint")] <- "PM 3sim c"
names(pms_ls)[which(pms_ls=="beta_sne_predint")] <- "PM 3nest c"
names(pms_ls)[which(pms_ls=="beta_sor_predint")] <- "PM 3sor c"
names(pms_ls)[which(pms_ls=="sp_rich_sd")] <- "PM 2 d"
names(pms_ls)[which(pms_ls=="beta_sim_sd")] <- "PM 3sim d"
names(pms_ls)[which(pms_ls=="beta_sne_sd")] <- "PM 3nest d"
names(pms_ls)[which(pms_ls=="beta_sor_sd")] <- "PM 3sor d"

filebody <- paste0(RDfinal, "/raw_res_fig") 
if (commSP) {
    filebody <- paste0(filebody, '_commSP')
}

### plot 1, raw results
pdf(file = paste0(filebody,".pdf"), 
    bg = "transparent", 
    width = 15, 
    height = 15)
	par(family = "serif", 
	    mfrow = c(5,4), 
	    mar = c(7,3,2,1))
	for (p in 1:length(pms)) {
		plot(0,0,
			 xlim = c(0,length(mod_names2)),
			 ylim = c(min(resTBL[,pms[p]], na.rm=T), max(resTBL[,pms[p]], na.rm = TRUE)),
			 type = "n",
			 xaxt = "n",
			 xlab = "",
			 ylab = "",
			 main = pms[p])
		for (m in 1:length(mod_names)) {
			lines(resTBL[which(resTBL$modelling.framework==mod_names[[m]]), pms[p]],
				  x = rep(m, 
				          times = length(resTBL[which(resTBL$modelling.framework==mod_names[[m]]),pms[p]])),
				  lwd = 2)
			points(mean(resTBL[which(resTBL$modelling.framework==mod_names[[m]]),pms[p]]),
				   x = m, 
				   pch = 21, 
				   col = "black", 
				   bg = "red3",
				   cex = 2)
		}
		axis(1, 1:length(mod_names), unlist(mod_names), las=2)
	}
dev.off()

### plot 2, with ranking and ordered PMs
filebody <- paste0(filebody, '_2')

ranking <- read.csv2(file = file.path(RDfinal, "ranking.csv"))
rank_order <- as.character( ranking[order(ranking[,3]),1] )
pms_names <- paste("PM", 
                   rep(c(1, 2, "3sim", "3nest", "3sor"), each = 4), 
                   rep(letters[1:4], times = 3))
pms_ls <- pms_ls[pms_names]

pdf(file = paste0(filebody, ".pdf"), 
    bg = "transparent", 
    width = 15, 
    height = 15)
	par(family = "serif", 
	    mfrow = c(5,4), 
	    mar = c(7,5,2,1))
	for (p in 1:length(pms_ls)) {
		plot(0, 0,
	 	xlim = c(0, length(rank_order)),
	 	ylim = c(min(resTBL[,pms_ls[[p]]], na.rm = TRUE), 
	 	         max(resTBL[,pms_ls[[p]]], na.rm = TRUE)),
	 	type = 'n',
	 	xaxt = 'n',
	 	ylab = names(pms_ls)[p],
	 	xlab = "",
	 	cex.axis = 2,
	 	cex.lab = 2.25)
		for (m in 1:length(rank_order)) {
			lines(y = resTBL[which(resTBL$modelling.framework==rank_order[m]), pms_ls[[p]]],
				  x = rep(m, times = length(resTBL[which(resTBL$modelling.framework==rank_order[m]), pms_ls[[p]]])),
				  lwd = 2)
			points(mean(resTBL[which(resTBL$modelling.framework==rank_order[m]), pms_ls[[p]]]),
				   x = m, pch = 21, col = "black", bg = "red3", cex = 2)
		}
		axis(1, 1:length(rank_order), rank_order, las = 2)
	}
dev.off()

### individual AUC plots
tmp <- resTBL[,c(which(colnames(resTBL)=="modelling.framework"),
                 which(colnames(resTBL)=="dsz"),
                 which(colnames(resTBL)=="predtypes.j."),
                 which(colnames(resTBL)=="set_no"),
                 which(colnames(resTBL)=="discrimination_auc"))]
tmp <- tmp[which(tmp$dsz=="150"),]
tmp_i <- tmp[which(tmp$predtypes.j.=="interpol"),]
tmp_e1 <- tmp[which(tmp$predtypes.j.=="extrapol"),]
tmp_e2 <- tmp[which(tmp$predType=="extrapol2"),]
tmp_i[,"discrimination1"] <- as.numeric(as.character(tmp_i[,"discrimination_auc"]))
tmp_e1[,"discrimination1"] <- as.numeric(as.character(tmp_e1[,"discrimination_auc"]))
tmp_e2[,"discrimination1"] <- as.numeric(as.character(tmp_e2[,"discrimination_auc"]))

filebody <- paste0(RDfinal, "/fig_3b") 
if (commSP) {
 filebody <- paste0(filebody, '_commSP')
}

for (d in 1:length(Sets)) {

	pdf(file = paste0(filebody, "_", Sets[d], ".pdf"),
		bg = "transparent",
        width = 5,
        height = 3.5)

		par(family = "serif", mar = c(6, 4, 0.1, 0.1))

		tmpPlot <- tmp_i[which(tmp_i$set_no==Sets[d]),]
		rownames(tmpPlot) <- tmpPlot[,1]
		plot(y = tmpPlot[rank_order, "discrimination_auc"],
			 x = 1:length(rank_order),
			 type = 'p',pch=21,
			 col = "black",
			 bg = "black",
			 xlab = "",
			 ylab = "Discrimination at species level",
			 xaxt = "n",yaxt="n",
			 ylim = c(0.5,0.9),
			 cex = 1.5)
		
		tmpPlot <- tmp_e1[which(tmp_e1$set_no==Sets[d]),]
		rownames(tmpPlot) <- tmpPlot[,1]
		points(y = tmpPlot[rank_order,"discrimination_auc"],
			   x = 1:length(rank_order),
			   pch = 21,
			   col = "black",
			   bg = "grey",
			   cex = 1.5)
		
		tmpPlot <- tmp_e2[which(tmp_e2$set_no==Sets[d]),]
		rownames(tmpPlot) <- tmpPlot[,1]
		points(y = tmpPlot[rank_order,"discrimination_auc"],
			   x = 1:length(rank_order),
			   pch = 21,
			   col = "black",
			   bg = "white",
			   cex = 1.5)
			   
		axis(1,
			 1:length(rank_order),
			 rank_order,
			 FALSE,
			 las = 2)
		axis(2,
			 c(0.5, 0.7, 0.9),
			 c(0.5, 0.7, 0.9),
			 las = 2)
			 
	dev.off()

}

# 6.2 plot convergences
#-----------------------------------------------------------------------------------------
rm(list = ls()[!(ls() %in% c("OS", "pth", "WD", "SETT"))]) 
gc()
setwd(WD)
commSP <- FALSE
source(SETT)

load(file = file.path(RDfinal, "covergences_res.RData"))
pdf(file = file.path(RDfinal, "convergences.pdf"), 
    bg = "transparent", 
    width = 15, 
    height = 7)
	par(family = "serif", 
	    mfrow = c(1,1), 
	    mar = c(7,5,2,1))
	boxplot(correlation ~ model, 
			data = covergences_res[,1:2],
			ylim = c(0,1),
			cex.label = 2,
			cex.axis = 1.5,
			las = 2)
dev.off()

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# End of pipeline
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
