#clear the environment
rm(list=ls())
graphics.off()

#install the required packages
install.packages("quantmod")
install.packages("fPortfolio")
install.packages("timeSeries")
install.packages("plot.matrix")

#load the required packages
library(quantmod)
library(fPortfolio)
library(timeSeries)
library(plot.matrix)

#import data from Yahoo Finance
getSymbols(c("BA", "DIS", "PG", "IBM", "KO", "JPM"), src = "yahoo", from = "2018-01-01", to = "2021-04-01")

#select the closing prices and transform them into timeSeries objects
BA <- as.timeSeries(BA$BA.Close)
DIS <- as.timeSeries(DIS$DIS.Close)
PG <- as.timeSeries(PG$PG.Close)
IBM <- as.timeSeries(IBM$IBM.Close)
KO <- as.timeSeries(KO$KO.Close)
JPM <- as.timeSeries(JPM$JPM.Close)

#plot the time series and add the mean-line
par(mfrow = c(3,2))
plot(BA, xlab = 'Time', ylab = 'Price', main = "Boeing", ylim=c(50,500))
abline(h=mean(BA), col="red", lty=3)
plot(IBM,  xlab = 'Time', ylab = 'Price', main = "IBM", ylim=c(80, 180))
abline(h=mean(IBM), col="red", lty=3)
plot(DIS, xlab = 'Time', ylab = 'Price', main = "Walt Disney", ylim=c(50,250))
abline(h=mean(DIS), col="red", lty=3)
plot(PG,  xlab = 'Time', ylab = 'Price', main = "Procter & Gamble", ylim=c(60, 160))
abline(h=mean(PG), col="red", lty=3)
plot(KO,  xlab = 'Time', ylab = 'Price', main = "Coca Cola", ylim=c(30, 70))
abline(h=mean(KO), col="red", lty=3)
plot(JPM,  xlab = 'Time', ylab = 'Price', main = "JP Morgan", ylim=c(60,180))
abline(h=mean(JPM), col="red", lty=3)

#close the graphical window
dev.off()

#compute the monthly returns
BA.returns=as.timeSeries(monthlyReturn(BA))
DIS.returns=as.timeSeries(monthlyReturn(DIS))
PG.returns=as.timeSeries(monthlyReturn(PG))
IBM.returns=as.timeSeries(monthlyReturn(IBM))
KO.returns=as.timeSeries(monthlyReturn(KO))
JPM.returns=as.timeSeries(monthlyReturn(JPM))

#plot the monthly returns
#par(mfrow=c(3,2))
#plot(BA.returns, ylab="Return", main="Boeing")
#plot(IBM.returns, ylab="Return", main="IBM")
#plot(DIS.returns, ylab="Return", main="Walt Disney")
#plot(PG.returns, ylab="Return", main="Procter & Gamble")
#plot(KO.returns, ylab="Return", main="Coca Cola")
#plot(JPM.returns, ylab="Return", main="JP Morgan")

#close the graphical window
#dev.off()

#compute the daily returns
BA.daily <- as.timeSeries(dailyReturn(BA))
DIS.daily <- as.timeSeries(dailyReturn(DIS))
PG.daily <- as.timeSeries(dailyReturn(PG))
IBM.daily <- as.timeSeries(dailyReturn(IBM))
KO.daily <- as.timeSeries(dailyReturn(KO))
JPM.daily <- as.timeSeries(dailyReturn(JPM))

#plot the daily returns
par(mfrow=c(3,2))
plot(BA.daily, ylab="Return", main="Boeing")
abline(h=mean(BA.daily), col="red", lty=3)
plot(IBM.daily, ylab="Return", main="IBM")
abline(h=mean(IBM.daily), col="red", lty=3)
plot(DIS.daily, ylab="Return", main="Walt Disney")
abline(h=mean(DIS.daily), col="red", lty=3)
plot(PG.daily, ylab="Return", main="Procter & Gamble")
abline(h=mean(PG.daily), col="red", lty=3)
plot(KO.daily, ylab="Return", main="Coca Cola")
abline(h=mean(KO.daily), col="red", lty=3)
plot(JPM.daily, ylab="Return", main="JP Morgan")
abline(h=mean(JPM.daily), col="red", lty=3)

#close the graphical window
dev.off()

#analyze the summaries of the monthly and daily data
colnames(BA.returns) <- c("BA")
summary(BA.returns)
colnames(IBM.returns) <- c("IBM")
summary(IBM.returns)
colnames(DIS.returns) <- c("DIS")
summary(DIS.returns)
colnames(PG.returns) <- c("PG")
summary(PG.returns)
colnames(KO.returns) <- c("KO")
summary(KO.returns)
colnames(JPM.returns) <- c("JPM")
summary(JPM.returns)

#summary(BA.daily)
#summary(IBM.daily)
#summary(DIS.daily)
#summary(PG.daily)
#summary(KO.daily)
#summary(JPM.daily)


#compute and show the mean of the returns 
names<-c("BA","DIS","PG", "IBM", "KO", "JPM")
mu.data<-c(mean(BA.returns), mean(DIS.returns), mean(PG.returns), mean(IBM.returns), mean(KO.returns), mean(JPM.returns))
names(mu.data)<-names
mu.data <- round(mu.data, 5)
mu.data


#compute and plot the variance-covariance and the correlation matrices
data<-cbind(BA.returns, DIS.returns, PG.returns, IBM.returns, KO.returns, JPM.returns)
cov<-cov(data)
dimnames(cov)<-list(names, names)
plot(cov, col="white", fmt.cell="%.4f", key=NULL, main="Variance - Covariance Matrix", xlab="", ylab="")
#cov

cor<-cor(data)
dimnames(cor)<-list(names, names)
cor.round <- round(cor, 4)
plot(cor, fmt.cell="%.4f", key=NULL, main="Correlation Matrix", xlab="", ylab="")
#alternatively
#heatmap.2(cor.round, cellnote = cor.round, notecol = "Black", trace = "none", main = "Correlation matrix", dendrogram = "none", revC = TRUE, key = FALSE, margins = c(5,5))
#cor
graphics.off()

#preliminary step, consider the s.d.
sd.data <- sqrt(diag(cov))
plot(sd.data, mu.data, xlim=c(0,0.2), ylim = c(0, 0.02), ylab = "Expected Return", xlab="Standard Deviation", main="Risk return trade-off", col = c(1:6), pch = 20, cex = 1.7)
text(sd.data, mu.data, labels=names, pos=3, col = c(1:6))

#efficient frontier with short selling vs our 6 stocks
#let's start by building some random weights for each stock 
n.prtf <- 2000 #number of random portfolios generated
set.seed(1) #this command is added in ordet to obtain always the same sample, it can be removed to create new random samples
rnd.BA <- runif(n.prtf, min=-0.8, max=0.8)
rnd.DIS <- runif(n.prtf, min=-0.8, max=0.8) 
rnd.PG <- runif(n.prtf, min=-0.8, max=0.8)
rnd.IBM <- runif(n.prtf, min=-0.8, max=0.8)
rnd.KO <- runif(n.prtf, min=-0.8, max=0.8)
rnd.JPM <- 1 - rnd.BA - rnd.DIS - rnd.PG - rnd.IBM - rnd.KO 

#plot the random portfolios
plot(sd.data, mu.data, ylim=c(-0.005,0.025), xlim=c(0.04, 0.15), xlab="Standard Deviation", ylab="Expected Return", main="Efficient Frontier")
for(i in 1:n.prtf){
  weights<-c(rnd.BA[i], rnd.DIS[i], rnd.PG[i], rnd.IBM[i], rnd.KO[i], rnd.JPM[i])
  mu.prtf<-crossprod(weights, mu.data)
  sd.prtf<-sqrt(t(weights)%*%cov%*%weights)
  points(sd.prtf,mu.prtf)
}

#compute the weights of the global minimum variance portfolio (GMVP)
vect.of.ones<-rep(1,6)
inv.cov<-solve(cov)
top<-inv.cov%*%vect.of.ones
bot<-as.numeric((t(vect.of.ones)%*%inv.cov%*%vect.of.ones))
m.mat<- top/bot
weights.min<-m.mat[,1]
#weights.min

#compute the mean and the standard deviation of the GMVP
mu.min<-crossprod(weights.min,mu.data)
mu.min
sd.min<-sqrt(t(weights.min)%*%cov%*%weights.min)
sd.min

#plot the GMVP 
points(sd.min, mu.min, col="dark blue", pch = 20, cex = 1.7)
text(sd.min, mu.min, col="dark blue", labels=" GMVP ", pos = 2, cex = 0.7)
#starting from the mean of the global min portf we start increasing the return computig the eff front

#compute and plot the efficient frontier in which we allow short selling
eff.front.short <- matrix(ncol=2)
colnames(eff.front.short) <- c("mu","sd")

k <- mu.min
while(k<=0.03){
  top.mat = cbind(2*cov, mu.data, rep(1, 6))
  mid.vec = c(mu.data, 0, 0)
  bot.vec = c(rep(1, 6), 0, 0)
  Ax.mat = rbind(top.mat, mid.vec, bot.vec)
  bmsft.vec = c(rep(0, 6), k , 1)
  z.mat = solve(Ax.mat)%*%bmsft.vec
  x.vec = z.mat[1:6,]
  x.vec
  
  mu.px = as.numeric(crossprod(x.vec, mu.data))
  sig2.px = as.numeric(t(x.vec)%*%cov%*%x.vec)
  sig.px = sqrt(sig2.px)
  mu.px
  sig.px
  eff.front.short<-rbind(eff.front.short,c(mu.px,sig.px))
  
  if(k==mu.min){
     points(sig.px, mu.px, col="blue", pch = 20, cex = 1.7)
  }
  else{
     points(sig.px, mu.px, col="green", pch = 20, cex = 1.4)
  }
  k=k+0.001
}

#remove first row which is made by NA
eff.front.short<-eff.front.short[-1,]

#compute the efficient frontier with short selling constraints
#preliminary step, change the nature of the monthly return objects
BA.returns=as.xts(monthlyReturn(BA))
DIS.returns=as.xts(monthlyReturn(DIS))
PG.returns=as.xts(monthlyReturn(PG))
IBM.returns=as.xts(monthlyReturn(IBM))
KO.returns=as.xts(monthlyReturn(KO))
JPM.returns=as.xts(monthlyReturn(JPM))

#merge the returns together
matrix.close<-merge(BA.returns, DIS.returns, PG.returns, IBM.returns, KO.returns, JPM.returns)
matrix.close<-as.timeSeries(matrix.close)
colnames(matrix.close)<-c("BA", "DIS","PG","IBM","KO","JPM")


#in order to compute this new efficient frontier rely on a function of the fPortfolio package
noshort<-portfolioFrontier(matrix.close, constraints = "LongOnly")
#noshort
#plot the efficient frontier and the new GMVP
#frontierPlot(noshort, frontier="upper", xlim=c(0.04, 0.16), ylim=c(0.005, 0.03), pch = 20, cex = 1.5, main="Efficient Frontier", )
eff.front.no.short <- frontierPoints(noshort, frontier = "upper")
plot(eff.front.no.short[,1], eff.front.no.short[,2], xlim=c(0.04, 0.1), ylim=c(0, 0.03), pch = 20, cex = 1.3, xlab="Risk", ylab="Return", main="Efficient Frontier")

GMVP.no.short <- minvariancePoints(noshort, col="red", pch = 20, cex = 1.7)
GMVP.no.short
text(GMVP.no.short[,1], GMVP.no.short[,2], col="red", labels=" GMVP ", pos = 2, cex = 0.7)

#make a comparison beetween the two efficient frontiers
#frontierPlot(noshort, frontier="upper", xlim=c(0.04, 0.16), ylim=c(0, 0.03), pch = 20, cex = 1.3)
plot(eff.front.no.short[,1], eff.front.no.short[,2], xlim=c(0.04, 0.16), ylim=c(0, 0.03), pch = 20, cex = 1.3, xlab="Risk", ylab="Return", main="Efficient Frontier")
minvariancePoints(noshort, col = "black", pch = 20, cex = 1.3)
points(eff.front.short[,2], eff.front.short[,1], col="green", pch = 20, cex = 1.3)
points(sd.data, mu.data, xlim=c(0,0.2), ylab="Expected Return", xlab="Standard Deviation", col = c(1:6), pch = 20, cex = 1.5 )
text(sd.data, mu.data, labels=names, pos=4, col=c(1:6), cex=0.7)
#minvariancePortfolio(matrix.close)


#since the efficient frontier without short selling constraints is more efficient, use it to make further analyses
##efficient frontier vs equally weighted portfolio (EW) and some indexes: Nasdaq, Nyse, Sp500 and Dow Jones
#import new data from Yahoo Finance
getSymbols(c("^GSPC", "^IXIC", "^DJI", "^NYA"), src="yahoo",from="2018-01-01")

#consider the closing prices
SP500<-GSPC$GSPC.Close
NASDAQ<-IXIC$IXIC.Close
DOW.JONES<-DJI$DJI.Close
NYSE<-NYA$NYA.Close

#compute the monthly returns
SP500.returns<-as.numeric(monthlyReturn(SP500))
NASDAQ.returns<-as.numeric(monthlyReturn(NASDAQ))
DOW.JONES.returns<-as.numeric(monthlyReturn(DOW.JONES))
NYSE.returns<-as.numeric(monthlyReturn(NYSE))

#compute the mean and the standard deviation of the equally weighted portfolio
eq.weights<-rep(1,6)/6
mu.eq<-crossprod(eq.weights, mu.data)
sd.eq<-sqrt(t(eq.weights)%*%cov%*%eq.weights)

#plot the efficient frontier vs the indexes and the EW 
plot(eff.front.short[,2], eff.front.short[,1], col="green", ylim=c(0.005,0.03), ylab="Expected Return", xlab="Standard Deviation", main="Risk return trade-off", pch = 20, cex = 1.4)
points(sqrt(var(SP500.returns)), mean(SP500.returns), col=1, pch = 20, cex = 1.4)
text(sqrt(var(SP500.returns)), mean(SP500.returns), labels="SP500", pos=2, col=1, cex=0.7)
points(sqrt(var(NASDAQ.returns)), mean(NASDAQ.returns), col=2, pch = 20, cex = 1.4)
text(sqrt(var(NASDAQ.returns)), mean(NASDAQ.returns), labels="NASDAQ", pos=1, col=2, cex=0.7)
points(sqrt(var(DOW.JONES.returns)), mean(DOW.JONES.returns),col=7, pch = 20, cex = 1.4)
text(sqrt(var(DOW.JONES.returns)), mean(DOW.JONES.returns), labels="DOW JONES", pos=2, col=7, cex=0.7)
points(sqrt(var(NYSE.returns)), mean(NYSE.returns), col=4, pch = 20, cex = 1.4)
text(sqrt(var(NYSE.returns)), mean(NYSE.returns), labels="NYSE", pos=2, col=4, cex=0.7)
points(sd.eq, mu.eq, col=6, pch = 20, cex = 1.4)
text(sd.eq, mu.eq, labels="EW", pos=1, col=6, cex=0.7)

graphics.off()

#compute the cumulative performance obtained through an investment in the GMVP of the efficient frontier without short selling constraints
cap<-1000 #starting capital
performances<-c() #empty vector to store the performances


for(n in 1:nrow(matrix.close)){
  
  if(n == 1)
    val<-cap #at the beginning invest the starting capital
  else
    val<-performances[n-1] #from the second "traiding-day" use the new capital
  
  performances[n] <- sum(val+val*crossprod(weights.min %*% t(matrix.close[n])))
  cap <- performances[n]
}
#plot the cumulative performance
plot(performances, type="l", xlab="Months", ylab="Capital", main="Cumulative Performance")

#performances

