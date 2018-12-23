##########################################################################################
# RAW RESULTS FOR PERFORMANCE MEASURES
##########################################################################################

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

source(file.path(SD, "pipe", "appendFilebody.r"))

filebody <- "TBL_PMS_ALL"
	if (commSP) { filebody <- paste0(filebody, "_commSP") }
	if (MCMC2) { filebody <- paste0(filebody, "_MCMC2") }
load(file=file.path(RDfinal,paste0(filebody,".RData")))

resTBL<-data.frame(TBL_PMS_ALL)
resTBL[,c(3:10,13:(ncol(resTBL)))]<-apply(resTBL[,c(3:10,13:(ncol(resTBL)))],2,as.numeric)

pms<-colnames(resTBL[,13:(ncol(resTBL))])
pms<-pms[c(1,2,4,3,
		5,9,17,13,
		6,10,18,14,
		7,11,19,15,
		8,12,20,16)]
# resTBL2<-resTBL
# resTBL[,minTomaxBest] <- -resTBL[,minTomaxBest]

filebody <- paste0(RDfinal, "/raw_res_fig") 
if (commSP) {
 filebody <- paste0(filebody, '_commSP')
}
if (MCMC2) {
 filebody <- paste0(filebody, '_MCMC2')
}

# plot 1
##########################################################################################
pdf(file=paste0(filebody,".pdf"), bg="transparent", width=15, height=15)
	par(family="serif",mfrow=c(5,4),mar=c(7,3,2,1))
	for (p in 1:length(pms)) {
		plot(0,0,
			 xlim=c(0,length(mod_names2)),
			 ylim=c(min(resTBL[,pms[p]], na.rm=T),max(resTBL[,pms[p]], na.rm=T)),
			 type='n',
			 xaxt='n',
			 xlab="",ylab="",
			 main=pms[p])
		for (m in 1:length(mod_names)) {
			lines(resTBL[which(resTBL$Abbreviation==mod_names[[m]]),pms[p]],
				  x=rep(m,times=length(resTBL[which(resTBL$Abbreviation==mod_names[[m]]),pms[p]])),
				  lwd=2)
			points(mean(resTBL[which(resTBL$Abbreviation==mod_names[[m]]),pms[p]]),
				   x=m,pch=21,col="black",bg="red3",cex=2)
		}
		axis(1,1:length(mod_names),unlist(mod_names),las=2)
	}
dev.off()

# plot 2
##########################################################################################
filebody <- paste0(filebody, '_2')

ranking <- read.csv2(file=file.path(RDfinal, "ranking.csv"))
rank_order <- as.character( ranking[order(ranking[,3]),1] )
pms_names <- paste("PM",rep(c(1,2,"3sim","3nest","3sor"),each=4),rep(letters[1:4],times=3))

pdf(file=paste0(filebody,".pdf"), bg="transparent", width=15, height=15)
	par(family="serif", mfrow=c(5,4), mar=c(7,5,2,1))
	for (p in 1:length(pms)) {
		plot(0,0,
	 	xlim=c(0,length(rank_order)),
	 	ylim=c(min(resTBL[,pms[p]], na.rm=T),max(resTBL[,pms[p]], na.rm=T)),
	 	type='n',
	 	xaxt='n',
	 	ylab=pms_names[p],
	 	xlab="",
	 	cex.axis=2,
	 	cex.lab=2.25)
		for (m in 1:length(rank_order)) {
			lines(resTBL[which(resTBL$Abbreviation==rank_order[[m]]),pms[p]],
				  x=rep(m,times=length(resTBL[which(resTBL$Abbreviation==rank_order[[m]]),pms[p]])),
				  lwd=2)
			points(mean(resTBL[which(resTBL$Abbreviation==rank_order[[m]]),pms[p]]),
				   x=m,pch=21,col="black",bg="red3",cex=2)
		}
		axis(1, 1:length(rank_order), rank_order,las=2)
	}
dev.off()

