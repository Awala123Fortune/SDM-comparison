##########################################################################################
# GET PREDICTIONS
##########################################################################################

if (MCMC2) {
  # HMSC
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(paste(PD, "predict.hmsc.all.r", sep = ""))

  # HMSC
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(paste(PD, "predict.hmsc.ss.r", sep = ""))

  # HMSC
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(paste(PD, "predict.hmsc.all.intXs.r", sep = ""))

  # HMSC
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(paste(PD, "predict.hmsc.ss.intXs.r", sep = ""))
  
  # GJAMS
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(file.path(PD, "predict.gjam.r"))
  
  # BayesComm
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(file.path(PD, "predict.bc.r"))
  
  # BORAL
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(file.path(PD, "predict.boral.r"))
  
  stop()
}

if (commSP) {
  # HMSC
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(file.path(PD, "predict.hmsc.all.r"))
  
  # GNNs
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(file.path(PD, "predict.gnn.r"))
  
  # MARS
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(file.path(PD, "predict.mars.r"))
  
  # MVABUND
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(file.path(PD, "predict.manyglm.r", sep = ""))
  
  # TRAITGLM
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(file.path(PD, "predict.traitglm.r"))
  
  # GJAMS
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(file.path(PD, "predict.gjam.r"))
  
  # SAMs
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(file.path(PD, "predict.sam.r"))
  
  # mistnet
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(file.path(PD, "predict.mistnet.r"))
  
  # BayesComm
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(file.path(PD, "predict.bc.r"))
  
  # BORAL
  rm(list = ls()[!(ls() %in% saveobjs)])
  gc()
  source(SETT)
  source(readdata)
  source(file.path(PD, "predict.boral.r"))
  
  stop()
}

# ss GLM 1
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.glm.r"))

# ss GLM 2
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.glmmPQL.r"))

# BRT
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.brt.r"))

# GNNs
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.gnn.r"))

# MARS
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.mars.r"))

# MVABUND
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.manyglm.r", sep = ""))

rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.traitglm.r"))

# GAM
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.gam.r"))

# RFs
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.rf.r"))

# MRTs
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.mrt.r"))

# XGB
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.xgb.r"))

# GJAMS
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.gjam.r"))

# SAMs
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.sam.r"))

# mistnet
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.mistnet.r"))

# BayesComm
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.bc.r"))

# BORAL
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.boral.r"))

# SVM
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.svm.r"))

# ss GLM 1
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(file.path(PD, "predict.glm.r"))

# ssHMSC
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(paste(PD, "predict.hmsc.ss.r", sep = ""))

# HMSC
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(paste(PD, "predict.hmsc.all.r", sep = ""))

# HMSC intXs
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(paste(PD, "predict.hmsc.all.intXs.r", sep = ""))

# ssHMSC intXs
rm(list = ls()[!(ls() %in% saveobjs)])
gc()
source(SETT)
source(readdata)
source(paste(PD, "predict.hmsc.ss.intXs.r", sep = ""))


##########################################################################################
