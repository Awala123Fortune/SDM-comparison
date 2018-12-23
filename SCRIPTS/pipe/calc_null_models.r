# FAILED MODELS

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

# from predictions folder
nullnames <- list("svmf1_isNULL_",
				  "rf1_isNULL_",
				  "glms1_isNULL_",
				  "glmnet1_isNULL_",
				  "glmmpql1_isNULL_",
				  "glmmpql_spat1_isNULL_",
				  "gam1_isNULL_",
				  "gam_spat1_isNULL_",
				  "brt1_isNULL_")

nullmodnames <- list("SVM1",
					 "RF1",
					 "GLM1",
					 "GLM10",
					 "GLM2",
					 "GLM3",
					 "GAM1",
					 "GAM2",
					 "BRT1")

Nulls <- array(NA,
				dim=list(length(Sets),
						 3,
						 2,
						 length(nullnames)),
				dimnames=list(Sets,
							  c('i','e1','e2'),
							  c('150','600'),
							  c(nullmodnames)))

for (l in 1:length(nullnames)) {
	for (sz in 1:length(c(1, 3))) {
			for (d in 1:length(Sets)) {

				set_no <- Sets[d]
				source(readdata)

				for (j in 1:3) {
					
					load(file = file.path(PD2,
										  set_no,
										  paste0(nullnames[[l]], 
												 j, 
												 "_", 
												 dataN[c(1,3)[sz]], 
												 ".RData")
												 ))
					Nulls[d,j,sz,l] <- round((sum(isNULL)/ncol(y_train[[j]]))*100)
			}	
		}
	}
}

TMP <- NA
for (l in 1:length(nullnames)) {
				tmp <- cbind(rbind(cbind(Nulls[,,1,l], '150'),
					               cbind(Nulls[,,2,l], '600')), nullmodnames[[l]])
				TMP <- rbind(TMP, tmp)
}
TMP <- TMP[-1,]
TMP <- data.frame(cbind(rownames(TMP), TMP), 
				  row.names=NULL)
TMP[,2:4] <- apply(TMP[,2:4], 2, as.numeric)
colnames(TMP)[c(1, (ncol(TMP)-1):ncol(TMP))] <- c("Taxon", "Data_size", "Model")

write.table(TMP, 
			file=file.path(RDfinal, "null_models.csv"), 
			sep=";", 
			row.names = FALSE,
            col.names = TRUE)

# fits folder
# no0sp_GJAM_3_600.RData