# Efficient-frontiers
The paper is organized into two parts. The first part aims to perform a simple descriptive analysis of 6 stocks downloaded from Yahoo Finance, while the goal of the second part is to build two efficient frontiers: one with the short selling constraints and the other without them.

At the end, the cumulative performance that would be by obtained investing in the Global Minimum Variance Portfolio of the best efficient frontier is computed as a sort of backtesting procedure.

#Preliminary steps
The first thing to do is to clear the environment and the graphical window, and to install and load the required packages.

In this paper we rely on four different packages, which allow us to exploit some useful functions. In particular:
the quantmode package is required to use the function getSymbols;
the fPortfolio package is necessary to implement some useful functions used to deal with the optimization constrained problem;
the timeSeries package is used to manage time series objects;
finally, the plot.matrix package is necessary to build more complex graphical representations, like for instance heatmaps.

