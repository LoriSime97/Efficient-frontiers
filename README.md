# Efficient-frontiers
The paper is organized into two parts. The first part aims to perform a simple descriptive analysis of 6 stocks downloaded from **Yahoo Finance**, while the goal of the second part is to build two efficient frontiers: one with the short selling constraints and the other without them.

At the end, the cumulative performance that would be by obtained investing in the Global Minimum Variance Portfolio of the best efficient frontier is computed as a sort of backtesting procedure.

## Preliminary steps
The first thing to do is to clear the environment and the graphical window, and to install and load the required packages.
In this paper we rely on 4 packages, which allow us to exploit some useful functions. In particular:

- the **quantmode package** is required to use the function *getSymbols*;
- the **fPortfolio package** is necessary to implement some useful functions used to deal with the optimization constrained problem;
- the **timeSeries package** is used to manage time series objects;
- finally, the **plot.matrix package** is necessary to build more complex graphical representations, like for instance *heatmaps*.

# Descriptive statistics
Relying on the getSymbols function, it is possible to download the data directly from Yahoo Finance.

The selected stocks are all listed in the Dow Jones index, which is made of 30 blue chips, i.e. big corporations commonly recognized for being of high quality and for having the ability to operate profitably both in good and bad times. Moreover, I chose to pick 6 firms operating in different businesses, in order to ensure a minimum level of diversification, and which have been part of the index for a long time. The idea was to analyze how different corporations have faced and are facing the Covid-19 pandemic; therefore the period considered goes from 1st January 2018 up to 1st April 2021.

The chosen stocks are:

- **Boeing** (BA), a company operating in the aerospace and defense industry;
- **IBM** (IBM), a huge firm of the IT sector;
- **The Walt Disney Company** (DIS), which is the largest worldwide provider of broadcasting and entertainment services:
- **Procter & Gamble** (PG), one of the most important producers of fast-moving consumer goods;
- **The Coca-Cola Company** (KO), an American multinational beverage corporation operating in the food industry;
- **JP Morgan** (JPM), a huge investment bank and financial services holding company.

Let us start by printing the time series of the stocks:

![stock time series](https://user-images.githubusercontent.com/90756113/133433923-44f735fd-344d-42c7-b538-d6716c10a308.png)


As we can notice, even if the stocks operate in different sectors, by looking at the plots, there seems to be a sort of relationship between some of them. In any case, a more precise measure of this relationship will be provided by the correlation matrix that we are going to see in a moment.

Before moving forward, it is interesting to highlight that, independently from the considered stock, we see a strong drawdown in the first months of 2020, that was due to the Covid-19 pandemic. Anyway, in most of the cases, there has been a following consistent rebound, thanks to the timely intervention of Central Banks and Governments, that mitigated the negative effects of the *2020 stock market crash*. Indeed, at the end of the analyzed period, only two stocks out of the six considered have a lower price than the one they started from (BA and IBM).

A clearer information about the volatility of those months is provided by another series of plots:

![daily returns](https://user-images.githubusercontent.com/90756113/133435923-ea55295b-f14b-4b1c-b124-8d89e27f8b98.png)


In the previous graphs, it is possible to see the daily returns of our stocks. Consistently with what has been said, the period between February and April 2020 has been characterized by a huge volatility. Moreover, even if now we are away from the peaks reached in that period, the volatility seems to be increased, meaning that there is a sort of persistence of higher values of volatility if compared with the pre-pandemic situation.

In the following table it is presented a list of significative variables that summarize what has been said so far.

```
##        BA           
##  Min.   :-0.457890  
##  1st Qu.:-0.081393  
##  Median :-0.009779  
##  Mean   : 0.006455  
##  3rd Qu.: 0.072217  
##  Max.   : 0.459312
```
```
##       IBM            
##  Min.   :-2.366e-01  
##  1st Qu.:-5.093e-02  
##  Median :-1.511e-03  
##  Mean   : 9.594e-05  
##  3rd Qu.: 4.935e-02  
##  Max.   : 1.825e-01
```
```
##       DIS           
##  Min.   :-0.178921  
##  1st Qu.:-0.041952  
##  Median :-0.008572  
##  Mean   : 0.016958  
##  3rd Qu.: 0.055621  
##  Max.   : 0.233631
```
```
##        PG          
##  Min.   :-0.09140  
##  1st Qu.:-0.01811  
##  Median : 0.01291  
##  Mean   : 0.01200  
##  3rd Qu.: 0.05224  
##  Max.   : 0.11366
```
```
##        KO           
##  Min.   :-0.172743  
##  1st Qu.:-0.014912  
##  Median : 0.017445  
##  Mean   : 0.005941  
##  3rd Qu.: 0.045403  
##  Max.   : 0.099204
```
```
##       JPM          
##  Min.   :-0.22461  
##  1st Qu.:-0.03170  
##  Median : 0.01619  
##  Mean   : 0.01197  
##  3rd Qu.: 0.05911  
##  Max.   : 0.20237
```
These are monthly data and even in this case we see something interesting. First of all, as we can see from the difference between the minimum and the maximum, there is a huge volatility. Secondly, the stocks returns are quite different one from the other, and this is also true for the mean of the returns:
```
##      BA     DIS      PG     IBM      KO     JPM 
## 0.00645 0.01696 0.01200 0.00010 0.00594 0.01197
```
As we see, the stock with the higher average return is Walt Disney, whereas the one with the lowest value is IBM. What can be said about the riskiness of those assets?

![variance - covariance matrix](https://user-images.githubusercontent.com/90756113/133436598-b21573be-a7d0-49b5-b35e-a32c6469ffbe.png)
![correlation matrix](https://user-images.githubusercontent.com/90756113/133436659-dc8d52ca-8302-490a-a81d-4f644df5de21.png)
With respect to the variance - covariance matrix, we notice that the less risky stock is Procter & Gamble, while the riskiest is Boeing. This makes sense if we keep in mind the period we are considering. In particular, on one hand, PG produces primary goods of common use, therefore we can suspect that their business is not affected too much by a pandemic. Regardless the situation, there are some goods that are necessary for everyday life. On the other hand, Boeing is a company which mostly produces airplanes. Therefore, it is normal that its business is hit hardly by the pandemic.

Considering the correlation matrix we notice something we do not like. Indeed, there are some relatively high values. Excluding the correlations between KO and DIS, and KO and PG, all the highest values regard correlations between JPM and other firms. Probably, this is due to the fact that JP Morgan is a huge investment bank which lends money to many different companies and has a lot of investments, therefore its returns are correlated with the ones of many other sectors and firms.

# Efficient frontier
In the second part of the paper we build two efficient frontiers: in the first one we allow to short sell the assets, while in the second one we forbid it. It means that the only difference is related to the weights we use: in the first case we consider both positive and negative weights, while in the second one we accept only positive weights. Notice that in both scenarios there is also another constraint: we wish to invest all the capital, therefore the weights must sum up to 1.

![risk return trade off](https://user-images.githubusercontent.com/90756113/133436834-3d61f244-b197-4ac3-8e71-f1118c5c7c95.png)

This plot shows the risk return profile of the 6 selected assets. What does it mean? It means that in this space the points are plotted using as coordinates their risk and return, i.e. their standard deviation and their mean. Moving from bottom to top the return increases, and moving from left to right the risk increases. It means that a point is efficient if given its risk it is not possible to find another point with the same risk and higher return, or if fixed the return it is the point with the lowest risk.

This allows us to draw some initial conclusions. In the first place, we already knew that DIS was the asset with the highest average return, therefore we are not surprised to see it at the top. At the same time, BA, which is the riskiest stock, is the furthest to the right. For instance, we can say that KO is not efficient since it has a lower return than PG which is less risky, but we cannot state much more.

More interesting information will be provided by the efficient frontier, which is the line representing the most efficient portfolios we can obtain with different combinations of the selected assets. In other words, the efficient frontier represents the optimal asset allocation we can get in each point.

## Efficient frontier without short selling constraints
The first step when building this line is to generate an arbitrarily large number of possible portfolios.
```
n.prtf <- 2000 #number of random portfolios generated
set.seed(1) #this command is added in order to obtain always the same sample, it can be removed to create new random samples
rnd.BA <- runif(n.prtf, min=-0.8, max=0.8)
rnd.DIS <- runif(n.prtf, min=-0.8, max=0.8) 
rnd.PG <- runif(n.prtf, min=-0.8, max=0.8)
rnd.IBM <- runif(n.prtf, min=-0.8, max=0.8)
rnd.KO <- runif(n.prtf, min=-0.8, max=0.8)
rnd.JPM <- 1 - rnd.BA - rnd.DIS - rnd.PG - rnd.IBM - rnd.KO 
```
By doing so, we create 2000 random portfolios. This is made in order to show that the efficient frontier is really efficient, meaning that it is not possible to obtain a higher return given that level of risk.

![efficient frontier without](https://user-images.githubusercontent.com/90756113/133436949-c9101676-5838-49fe-8a66-eb9b6b9572e9.png)


In the plot above it is possible to see the efficient frontier we get when there are no short selling constraints. Particularly, the GMVP, i.e. the global minimum variance portfolio, is the less risky combination we are able to find with those assets. It is interesting to notice that this portfolio has a lower variability than any other possible portfolio and than the starting assets. It means that by combining different stocks we can exploit some diversification effects reducing the total amount of risk.

In our case, the GMVP is characterized by the following values:
```
mu.min
##            [,1]
## [1,] 0.01078754
```
```
sd.min
##            [,1]
## [1,] 0.04618212
```
Remember that the less risky asset is PG which has a variance of 0.0026, meaning a standard deviation of 0.051. Therefore, since the GMVP has a standard deviation of 0.046, we can conclude that we were able to reduce the risk.

## Efficient frontier with short selling constraints
In order to deal with the constraints I decided to use the *fPortfolio package* which provides some useful functions allowing us to compute the constrained frontier. In particular, in this case we want to have only positive weights.
```
##   targetRisk targetReturn
## 1 0.04640685   0.01091607
## attr(,"control")
##   targetRisk targetReturn         auto 
##        "Cov"       "mean"       "TRUE"
```
![efficient frontier with](https://user-images.githubusercontent.com/90756113/133437190-d35c10fe-a4a3-4ee8-a0eb-f083621ec4c8.png)


This is the result we obtain. Again, we see that it has a very small risk, 0.0464, which is extremely close to the value of the previous efficient frontier, 0.0461. However, this second line appears to be flatter. Is it true? In order for us to answer, it is necessary to plot them together. To provide a deeper analysis I decided to plot also the assets.

![comparison](https://user-images.githubusercontent.com/90756113/133437445-dca35e1d-dc49-4798-9734-fe098f895247.png)


From this comparison it is possible to draw some interesting conclusions. Firstly, the efficient frontier without the short selling constraints appears to perform better than the one constrained. This is logical. Indeed, in the first case we are exploiting more possibilities, allowing to have also negative weights. Therefore, it makes sense that it is able to achieve a more efficient performance. In the second place, we see that in the case in which we consider only positive weights for the assets, the highest return we can obtain is exactly the highest return among the assets themselves, meaning that, in our example, in order to achieve it, we have to invest all our capital in Disney.

This is not true if we introduce the possibility of short sells: in this case, it is possible to obtain higher results. The last thing we can say is about the stocks. Indeed, Boeing and IBM seem to be the less efficient assets among the selected ones, whereas PG and DIS appear to be the most efficient.

Since the efficient frontier without short selling constraints is the most efficient, I chose to make a further comparison between it and some proxies. In particular, I consider four indexes and the equally weighted portfolio, i.e. the portfolio in which all the assets have the same weight.

The chosen indexes are:

- the **Dow Jones**, which has been already presented;
- the **S&P500**, a stock market index made of 500 large companies which together represent about 80% of the entire capitalization of the U.S. market;
- the **Nasdaq**, which is essentially the index of IT companies;
- the **NYSE**, a stock market index covering all common stocks listed on the New York Stock Exchange, which is the world’s largest stock exchange.

![new comparison](https://user-images.githubusercontent.com/90756113/133437707-e93c4957-b8ad-4d5d-b3d1-dc14f5675395.png)


Even in this case, we see that the efficient frontier performs better than the benchmarks. Anyway, we have to highlight the fact that all these indexes seem to be more efficient than the single assets. Indeed, while only two stocks have a standard deviation smaller than 0.06, in this case all the proxies lie below this level. This is probably due to fact that, being made by multiple stocks, there is a *compensation effect* that tends to mitigate the riskiness of the single assets. It is also interesting to notice that the equally weighted portfolio appears to be the less efficient. It means that a *naive diversification* in which we invest an equal amount of money in each assets is not truly efficient.

# Backtesting procedure
The last part of the paper consists in a sort of backtesting procedure. The aim of the project is not to develop a trading strategy, but it is to perform a descriptive analysis of some securities and to build the two possible efficient frontiers. Therefore, I decided to test the results that would have been obtained investing in the GMVP of the most efficient frontier.

![backtesting procedure](https://user-images.githubusercontent.com/90756113/133439950-aec00ed2-cd4f-4c3f-bf7c-d375a7a09549.png)


It is possible to notice that the result is pretty good. Starting from an initial capital of 1000€ the final value is 1499.897€, meaning a cumulative performance of **+49.98%**.
