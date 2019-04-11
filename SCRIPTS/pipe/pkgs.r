#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# INSTALL PACKAGES
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

install.packages(c("pROC",
				   "mvabund",
				   "randomForest",
				   "caret",
				   "e1071",
				   "gbm",
				   "dismo",
				   "yaImpute",
				   "earth",
				   "devtools",
				   "glmnet",
				   "boral",
				   "gjam",
				   "spaMM",
				   "nlme",
				   "MASS",
				   "spaMM",
				   "vegan",
				   "BayesComm",
				   "mvtnorm",
				   "parallel",
				   "kmed",
				   "xgboost"))
require(devtools)
install_github('davharris/mistnet2')
install_github('goldingn/BayesComm')

install.packages(paste0(WD,"/sdmCom_0.1.tar.gz"), 
                 repos = NULL, 
                 type = "source") 
install.packages(paste0(WD,"MODELS/mvpart_pkg/mvpart_1.6-2.tar"), 
                 repos = NULL, 
                 type = "source") 

if (OS == "osx" | OS == "unix") { 
	install.packages("doMC")
	}
if (OS == "win") {
	install.packages("doParallel")
	}

