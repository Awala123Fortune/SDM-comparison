
mod_pred_comm_sp <- function(directory, pred_name, sps) {
	
        model <- local({ load(file.path(directory, pred_name))
                stopifnot(length(ls())==1)
                environment()[[ls()]]
        })

        pred_comms <- simplify2array(model)
        pred_comms <- as.array(pred_comms)
        if ( any(is(pred_comms) == "simple_sparse_array") ) {
            pred_comms <- array(pred_comms$v, dim = pred_comms$dim)
        }
        res <- pred_comms[,sps,]
        return(res)
}
