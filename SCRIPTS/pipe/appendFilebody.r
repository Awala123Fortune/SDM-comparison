appendFilebody <- function(filebody=NULL, 
						   ensmblModels=NULL, 
						   nmodels=NULL, 
						   commSP=NULL, 
						   MCMC2=NULL) {

	if ( !is.null(ensmblModels) ) {
		if ( length(ensmblModels) == nmodels ) { ensmbl <- "all" }
		if ( length(ensmblModels) != nmodels ) { ensmbl <- paste(ensmblModels, collapse="_") }
		filebody <- paste0(filebody, "ensmbl_", ensmbl, "_")
	}
	if (commSP) {
		filebody <- paste0(filebody,"commSP_")	
	}
	if (MCMC2) {
		filebody <- paste0(filebody,"MCMC2_")	
	}
	return(filebody)
}
