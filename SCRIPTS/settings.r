#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PATHS, ASSIGNMENTS, ETC.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

dataN <- c(150,300,600)			# data sizes
REPs <- 100						# no. of prediction replicates
dszs <- c(1, 3)

Sets <- c("birds","butterfly","plant","trees","vegetation")
betaInds<-c("sim", "nest", "sor")


# basic working directories
#-----------------------------------------------------------------------------------------
WD <- file.path(pth,"bakeoff","pipeline")

# scripts directory
SD <- file.path(WD,"SCRIPTS")

# data directory
DD <- file.path(WD,"DATA")

# model fitting scripts directory
MD <- file.path(WD,"MODELS")

# model fits directory
FD <- file.path(WD,"FITS")

if (!commSP) {
	FD <- file.path(WD,"FITS2")
}
if (commSP) {
	FD <- file.path(WD,"FITS_commSP")
}

# prediction scripts directory
PD <- file.path(WD,"PREDICT")

# predictions directory
PD2 <- file.path(WD,"PREDICTIONS")

# scripts directory for prev., rich, co-occ, etc. calculations
RD <- file.path(WD,"RESULTS")

# predictions  directory for prev., rich, co-occ, etc. calculations  (desktops)
RD2 <- file.path(WD,"RESULTS2")

# final results directory
RDfinal <- file.path(WD,"RESULTS_final")

DIRS <- c(WD, DD, MD, FD, PD, PD2, RD, RD2, RDfinal)

# read data
readdata <- file.path(SD, "read.data.r")

# fit models
fitmodels <- file.path(SD, "pipe", "fit_models.r")

# make predictions
makepreds <- file.path(SD, "pipe", "pred.r")

# objects saved when removing everything else from workspace
#-----------------------------------------------------------------------------------------
saveobjs <- c("sz","d","set_no","REPs","SETT","readdata","fitmodels","makepreds",
			  "modpredsFolder","modpreds","dataN","saveobjs","Sets","betaInds",
			  "pth","WD","SD","DD","MD","FD","PD","PD2","RD","RD2","RDfinal",
			  "MCMC2","commSP","intXs")
saveobjs2 <- c(saveobjs,"PMs","PMS","ENS","PRVthr")

# models
#-----------------------------------------------------------------------------------------
mod_names <- list("GAM1","GAM2",
				  "GLM1","GLM8","GLM12",
				  "GLM10","GLM11",
				  "GLM2","GLM3",
				  "GLM6",
				  "GLM9",
				  "MRTS1",
				  "GNN1",
				  "RF1",
				  "BRT1",
				  "XGB1",
				  "SVM1",
				  "MARS1","MARS2",
				  "GJAM1",
				  "SAM1",
				  "MISTN1",
				  "GLM7","BORAL1",
				  "BC1","BC2",
				  "GLM4","GLM5","GLM13",
				  "HMSC1","HMSC2","HMSC3","HMSC4")
mod_names2 <- c(rep("GAM",2),
				rep("GLM",9),
				"MRTS",
				"GNN",
				"RF",
				"BRT",
				"XGB",
				"SVM",
				rep("MARS",2),
				"GJAM",
				"SAM",
				"MISTN",
				"GLM",
				"BORAL",
				rep("BC",2),
				rep("GLM",3),
				rep("HMSC",4))
				
mod_names3 <- c("GAM","GAMspat1",
				"GLM1","GLM1b","GLM1_intXs",
				"GLMNET1","GLMNET1b",
				"GLMPQL1","GLMPQLspat1",
				"MVABUND1",
				"TRAITGLM1",
				"MRTS1",
				"GNN1",
				"RF1",
				"BRT1",
				"XGB1",
				"SVM1",
				"MARS1","MARS2",
				"GJAM1",
				"SAM1",
				"MISTN1",
				"BORAL1","BORAL2",
				"BC1","BC2",
				"hmsc1","hmsc2","hmsc1_inXs",
				"hmsc1","hmsc2","hmsc3","hmsc1_inXs")
# cbind(mod_names,mod_names2,mod_names3)
nmodels <- length(mod_names)
models <- 1:nmodels
nfrmwrks <- length(unique(mod_names2))

# predictions
#-----------------------------------------------------------------------------------------
pred_names	<-	list("gam1_PAs_","gam_spat1_PAs_",
				"glm1_PAs_","glm1b_PAs_","glm1_intXs_PAs_",
				"glmnet1_PAs_","glmnet1b_PAs_",
				"glmmPQL1_PAs_","glmmPQLspat1_PAs_",
				"manyglm1_PAs_",
				"traitglm1_PAs_",
				"mrt1_PAs_",
				"gnn1_PAs_",
				"rf1_PAs_",
				"brt1_PAs_",
				"xgb1_PAs_",
				"svm1_PAs_",
				"mars1_PAs_","mars2_PAs_",
				"gjam1_PAs_",
				"sam1_PAs_",
				"mstnt1_PAs_",
				"boral1_PAs_","boral2_PAs_",
				"bc1_PAs_","bc2_PAs_",
				"ss_hmsc1_PAs_","ss_hmsc2_PAs_","ss_hmsc1_intXs_PAs_",
				"hmsc1_PAs_","hmsc2_PAs_","hmsc3_PAs_","hmsc1_intXs_PAs_")

names(pred_names)<-mod_names

pred_names_notJoint	<-	list("gam1_PAs_","gam_spat1_PAs_",
							 "glm1_PAs_","glm1b_PAs_","glm1_intXs_PAs_",
							 "glmnet1_PAs_","glmnet1b_PAs_",
							 "glmmPQL1_PAs_","glmmPQLspat1_PAs_",
			 				 "mrt1_PAs_",
							 "gnn1_PAs_",
							 "rf1_PAs_",
							 "brt1_PAs_",
							 "xgb1_PAs_",
							 "svm1_PAs_",
							 "ss_hmsc1_PAs_","ss_hmsc2_PAs_","ss_hmsc1_intXs_PAs_")

pred_names_bayes <- list("gjam1_PAs_",
						 "boral1_PAs_","boral2_PAs_",
						 "bc1_PAs_","bc2_PAs_",
						 "ss_hmsc1_PAs_","ss_hmsc2_PAs_","ss_hmsc1_intXs_PAs_",
						 "hmsc1_PAs_","hmsc2_PAs_","hmsc3_PAs_","hmsc1_intXs_PAs_")
mod_names_bayes <- list("GJAM1",
						"GLM7","BORAL1",
						"BC1","BC2",
						"GLM4","GLM5","GLM13",
						"HMSC1","HMSC2","HMSC3","HMSC4")

names(pred_names_bayes) <- mod_names_bayes
								 

if (length(mod_names)!=length(pred_names)) {
	stop("Prediction objects and their names are of different size")
}

#-----------------------------------------------------------------------------------------
