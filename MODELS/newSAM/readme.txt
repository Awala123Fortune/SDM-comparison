Hi Anna and All (again),

My last email has sparked a little flurry of activity regarding the SAM code -- Francis got involved ;-)

In any case, you should (?) use the updated version of the code attached.  It fixes a number of small and large bugs.  Notably:

1. An error is thrown if there is non-convergence for all the repeat starts.
2. Completely random starts have been replaced with k-means/ k-medoids (which are still partially stochastic).  This gets the fit into a 'good' area
  of the parameter space.
3. K-medoids is used to generate starting values (Francis' idea).  This is to stop some of the funniness with very rare species.  This may not work
  for all data, but it seems to for the data we have been looking at.
4. Previously, only the last fit was used even though 10 fits were made.  There was no attempt at trying to find the 'best' fit of those made.
5. There is some disagreement between various options (k-means and k-medoids) and speciesMix.  This is worrisome, but I have no idea which is
  'right'.  I suspect that with more data, the differences will go away -- I reckon that there is an over-fitting thing going on.

There is code attached and a simple script to call it.  Please drop into your workflow as you see fit.

I'm still particularly concerned about the rare species thing. The problem is actually worse than I thought.  There is a species that has exactly 0 (zero) presences in the training data.  With binary data, even with 12+ presences, there is still a pretty good chance of getting quasi/complete-separation, which will muck things up.  I suspect that any principled approach (in terms of method comparison) would have to remove, at least temporarily, rare species.

I have also had a very quick look at the glmnet fit and predictions.  From my understanding, the fit is fine (up to rarity), but the choice of penalty appears to be random.  And it is a different random amount for each species.  Is this intentional?  I have never seen this before.  Normally, the penalty is chosen to produce the best predictions (through CV or some such thing -- even a specially design information criterion, e.g. ERIC).  Both David and Francis would have a firm grasp on this too.

The glmnet looks like it might behave oddly when there are very rare species.  You can think of the penalty indexing from all-zero-estimates to the unconstrained estimates.  But with really rare species, the unconstrained estimate is non-unique -- so what happens?  I don't know.  I don't know if glmnet was designed with this in mind at all...

Happy to discuss further, if you want.

Scott