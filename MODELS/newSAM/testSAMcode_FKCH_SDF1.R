rm(list = ls())
load("forFrancis_3Sept2018.RData")

#check out the prevalences
print( colSums( Y))
#blimey!  There is a species with 0 presences!
print( sum( colSums( Y) > ncol( X)))
#So there are only 16 species (out of 63) that have more presences than covariates

source( "coordinSAMsv2_SDF.R")

####################
## FKCH modification 030918
####################
startvals <- get.startvals(X = X, y = Y, K = 3, family = "binomial", tol = 0.1, method = "kmeans")

# Yikes those coefficients are bad due to rare species! I agree likely some strong quasi separation issues going on here. 
fit0 <- manyglm(Y ~ X, family = "binomial")

# library(kmed)
# mrwdist <- distNumeric(t(fit0$coefficients[-1,]), t(fit0$coefficients[-1,]), method = "mrw")
# result <- fastkmed(mrwdist, ncluster = 3, iterate = 50)

startvals <- get.startvals(X = X, y = Y, K = 3, family = "binomial", tol = 0.1, method = "kmedoids")


#superficially, this model below appears to fit.  BUT IT DOESN'T!
#It goes through 10 restarts and then spits out the 'best' non-fitting model
#at each restart, at the second iteration, glmnet estimates stupid coefficients.
#I think that this is likely to be due to there being more parameters than presences,
#In particular, when there are 1 (or 0) presences there are only 2 glmnet solutions -- All zeros or 
#a saturated fit.
#I don't know why all the rare species should group together though.
#Perhaps there is somthing with the initialisation?  But you give rare species random coefficients...

fm_kmeans <- psams.coord(X=X, y=Y, family="binomial", K=3, restarts=10, max.steps=100, trace=TRUE, start.method = "kmeans")

fm_kmed <- psams.coord(X=X, y=Y, family="binomial", K=3, restarts=10, max.steps=100, trace=TRUE, start.method = "kmedoids")

####################################################
####  Testing against ecomix/speciesmix for non-rare species

library( ecomix)#from github skiptoniam/ecomix

set.seed( 747)

notReallyReallyRare <- which( colSums( Y) > 2*ncol(X))

S.tot <- ncol( Y)
S <- length( notReallyReallyRare)
n <- nrow( X)
p <- ncol( X)

my.data <- cbind( Y, X)
colnames( my.data)  <- c( paste0("spp",1:S.tot), paste0("covariate",1:p))
my.data <- as.data.frame( my.data)

my.formula.outcomes <- paste0( "cbind( ", paste0( colnames( my.data)[notReallyReallyRare], collapse=","),")", collapse="")
my.formula.lp <- paste0( colnames( my.data)[S.tot+1:p], collapse="+")
my.formula <- paste0( my.formula.outcomes,"~",my.formula.lp)
my.formula <- as.formula( my.formula)

fm_sam <- species_mix( archetype_formula = my.formula, species_formula = ~1, data=my.data, n_mixtures=2, distribution="bernoulli")
fm_kmeans <- psams.coord(X=X, y=Y[,notReallyReallyRare], family="binomial", K=2, restarts=100, max.steps=100, trace=TRUE, start.method = "kmeans")
fm_kmed <- psams.coord(X=X, y=Y[,notReallyReallyRare], family="binomial", K=2, restarts=100, max.steps=100, trace=TRUE, start.method = "kmedoids")

coef( fm_sam)$beta
fm_kmeans$betas
fm_kmed$betas

#looking at choosing K
fm_sam <- list()
fm_kmed <- list()
for( kk in 2:10){
  fm_sam[[kk]] <- species_mix( archetype_formula = my.formula, species_formula = ~1, data=my.data, n_mixtures=kk, distribution="bernoulli")
  fm_kmed[[kk]] <- psams.coord(X=X, y=Y[,notReallyReallyRare], family="binomial", K=kk, restarts=10, max.steps=100, trace=TRUE, start.method = "kmedoids")
}
rbind( sapply( fm_sam, function(x) x$BIC), sapply( fm_kmed, function(x) x$ics[2]))
