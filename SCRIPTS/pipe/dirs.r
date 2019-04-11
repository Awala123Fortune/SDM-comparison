#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DIRECTORIES
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

dir.create(PD2)
dir.create(RD2)
for (set in Sets) {
	dir.create(paste0(RD2, set))
	}
dir.create(RDfinal)
dir.create(paste0(RDfinal, "150/"))
dir.create(paste0(RDfinal, "300/"))
dir.create(paste0(RDfinal, "600/"))
dir.create(paste0(RDfinal, "150/meta_analysis"))
dir.create(paste0(RDfinal, "300/meta_analysis"))
dir.create(paste0(RDfinal, "600/meta_analysis"))

#-----------------------------------------------------------------------------------------
