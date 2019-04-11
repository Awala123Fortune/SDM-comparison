list_preds <- function(directory, pred_list) {
    
    for (i in 1:length(pred_list)) {

        filebody <- file.path(directory, 
                              paste0(names(pred_list[[i]]), 
                                     ".RData"))
        if (file.exists(filebody)) {

            model <- local({
                load(filebody)
                stopifnot(length(ls())==1)
                environment()[[ls()]]
            })

            pred_comms <- simplify2array(model)
            pred_comms <- as.array(pred_comms)

            if ( any(is(pred_comms) == "simple_sparse_array") ) {
                pred_comms <- array(pred_comms$v, dim = pred_comms$dim)
            }

        pred_list[[i]][[1]]$predictions <- pred_comms

        } else {
            stop(paste0("File not found: ", filebody))
        }
    
    }

    return(pred_list)

}
