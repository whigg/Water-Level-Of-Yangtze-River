# Save Result to .pdf File
pdf("Yangtze.pdf")

# Read Data from .csv File
yangtze       <- read.table("Yangtze.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)
yangtze[2:19] <- apply(yangtze[2:19], 2, as.numeric)
yangtze$Date  <- as.Date(yangtze$Date, "%d/%m/%Y")
yangtze[yangtze == 0] <- NA

# Remove Outliers
	# 1-Analysis
boxplot(yangtze[2:19],
	main="Before Removing Outliers",
	xlab="Location", ylab="Level / Meter")
QL    <- apply(yangtze[2:19], 2, quantile, probs=0.25, na.rm=TRUE)
QU    <- apply(yangtze[2:19], 2, quantile, probs=0.75, na.rm=TRUE)
QU_QL <- QU - QL
UnU   <- QU + 1.5*QU_QL
UnL   <- QL - 1.5*QU_QL
	# 2-Removing
for (i in seq(2, 19, 1)) {
	yangtze[which( yangtze[i] > UnU[names(yangtze[i])] ), i] <- NA
	yangtze[which( yangtze[i] < UnL[names(yangtze[i])] ), i] <- NA
}
boxplot(yangtze[2:19],
	main="After Removing Outliers",
	xlab="Location", ylab="Level / Meter")

# Summary
summary(yangtze)
vars1 <- c("FuLing", "WanXian", "MaoPing")
vars2 <- c("YiBin", "LuZhou", "ChongQing", "YiChang", "ShaShi", "JianLi", "ChengLingJi",
	"HanKou", "HuangShi", "JiuJiang", "AnQing", "WuHu", "NanJing", "ZhenJiang", "XiangJiangChangSha")

# Draw Plot
for (i in list(vars1, vars2)) {
	len = length(i)
	cols <- rainbow(len)
	plot(yangtze$Date, t(yangtze[i[1]]),
		main="Water Level of Yangtze River",
		xlab="Time", ylab="Level / Meter",
		ylim=c(min(yangtze[i], na.rm=TRUE), max(yangtze[i], na.rm=TRUE)),
		type="l", col=cols[1])
	for (j in seq(2, len, 1)) {
		lines(yangtze$Date, t(yangtze[i[j]]), col=cols[j])
	}
	yLabel1 <- c("2006-1-1", "2008-1-1", "2010-1-1", "2012-1-1", "2014-1-1", "2016-1-1", "2018-1-1")
	yLabel1 <- as.Date(yLabel1)
	yLabel2 <- c("2007-1-1", "2009-1-1",	"2011-1-1", "2013-1-1", "2015-1-1", "2017-1-1")
	yLabel2 <- as.Date(yLabel2)
	abline(h=seq(-10, 180, 10), v=yLabel1, lty=2, col="black")
	abline(h=seq( -5, 180, 10), v=yLabel2, lty=2, col="grey")
	library(Hmisc)
	minor.tick(nx=0, ny=10, tick.ratio=0.5)
	legend("topleft", inset=.025, title="Location", names(yangtze[i]), lty=rep(1, len), col=cols)
}