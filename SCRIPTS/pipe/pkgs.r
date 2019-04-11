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
install_url('https://cran.r-project.org/src/contrib/Archive/BayesLogit/BayesLogit_0.6.tar.gz')
install_github('hmsc-r/HMSC')

if (OS == "osx" | OS == "unix") { 
	install.packages("doMC")
	install.packages(paste(WD,"MODELS/mvpart_pkg/mvpart_1.6-2.tar",sep=''), 
					 repos = NULL, 
					 type = "source") 
	}
if (OS == "win") {
	install.packages("doParallel")
	install.packages(paste(WD,"MODELS/mvpart_pkg/mvpart_1.6-2.zip",sep=''), 
					 repos = NULL, 
					 type = "source")
	}

