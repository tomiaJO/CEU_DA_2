
## user notes - some lines are commented out with a single '#'
## as it is not needed for solving the exercise, 
## just used for checking results or data understanding


### Question 1.
## Q: Use the amazon_compare.csv file and choose a city to analyze. (Load it into Stata or R)

## A: 
df <- read.csv('amazon_compare.csv', header = TRUE)

# head(df)
# str(df)
# names(df)

### Question 2.
## Q: Drop observations where price or price online or both are missing. 

# summary(df$price) ## 0 NA values
# summary(df$price_online) ## 1310 NA values
# nrow(df) ##3992 rows in total
# nrow(df[is.na(df$price_online) == FALSE, ]) ## 2682 rows in total where online price is not missing

## A: creating a new df where NOT both variables are missing
df_filtered <- df[!(is.na(df$price_online) | is.na(df$price)), ] 
# nrow(df_filtered) ## checking results ## numbers of rows are 2682 in the new dataset

## Q: Drop observations that are larger than the 99-percentile.
df_filtered <- df_filtered[df_filtered$price <= quantile(df_filtered$price, .99), ]
df_filtered <- df_filtered[df_filtered$price_online <= quantile(df_filtered$price_online, .99), ]

## Q: How do you call these observations? 
## A: Outliers

## Q: Make an argument on why should we keep them in the sample. 
## A: Generally, in absence of data quality issues, every observation in the sample carries added value.
## This means that disregarding them from the analysis might be misleading, as we are not considering valid data.
## Most cases, withour proper understanding (more on this in the next answer) of outliers, they should not 
## be removed.

## Q: Make another argument on why should we drop them.
## A: Easiest explanation is that they could carry data issues, and might not be valid observations.
## But let's consider another reason: there might be a reason of them being outliers, which are not
## captured in our variables, and we might be fine with that. A silly example could be the following:
## consider we want to build a model to explain house prices in our neighbourhood. There is one outlier, 
## where the price is double per sqr meter compared to other examples. With understanding our data, we
## get to know that that house was owned by a celebrity. If we want to model general house prices, we
## obviously know that celebrities are rare in the area, hence this one example might not be descriptive
## for others, and we could decide that we rather have a simpler model disregarding this attribute, than 
## trying to model this special circumstance.


### Question 3.
## Q: Create a random number generator from a distribution of your own choice setting the seed equal
## to your group number. Call this variable id_rand. 

## A: set seed to 11
set.seed(11)

## A: std normal distribution, mu = 0, sigma = 1, 10000 runs
id_rand <- rnorm(10000, 0, 1)

## Q: Sort the variable and select the first 1000 observation in your dataset

## A: ranked from highest to lowest, only picking the first 1000 numbers
sort(id_rand, decreasing = TRUE)[1:1000]

### Question 4.
## Q: Make summary statistics (mean, standard deviations, quartiles, percentiles) of the variables price
## and online price. 

## A: mean
mean(df_filtered$price)
mean(df_filtered$price_online)

## A: standard deviation
sd(df_filtered$price)
sd(df_filtered$price_online)

## A: quartiles
quantile(df_filtered$price, c(0, .25, .50, .75, 1))
quantile(df_filtered$price_online, c(0, .25, .50, .75, 1))

## A: percentiles
pct <- seq(from = 0, to = 1, by = 0.01)
quantile(df_filtered$price, pct)
quantile(df_filtered$price_online, pct)

## Q: Are there any differences between these statistics?
## A: 

### Question 5.

## Q: Create a variable two variables in your dataset: i) variance of the price variable, 
## A:
price_var <- sum( (df_filtered$price - mean(df_filtered$price)) ^ 2 ) / nrow(df_filtered)

## Q: and ii) it’s standard deviation (using the formula included in your Handout and Slides). 
## A:
price_std_dev <- price_var ^ .5

## Q: How do they compare to the variance and standard deviations you got using Built-in commands
## A:
price_var
var(df_filtered$price)

price_std_dev
sd(df_filtered$price)

# ?sd
# ?var

## A cont'd: They are slightly different, as R uses a denominator of n - 1 in its built-in 
## formulas, to create unbiased estimators (it assumes it runs on a sample of the population basically)

### Question 6.
## Q: Create a dummy (indicator) variable in case the price is greater than the online price.
## A: 
df_filtered$dummy1 <- df_filtered$price > df_filtered$price_online

summary(df_filtered$dummy1)

### Question 7.
## Q: Create a variable that is the difference between the price and online price. Call this variable diff_price. 
## A: 
df_filtered$diff_price <- df_filtered$price - df_filtered$price_online

## Q: Create a dummy variable taking value one if the diff_price is positive. 
## A:
df_filtered$dummy2 <- df_filtered$diff_price > 0

## Q: How does this variable compare to the one above?
## A: they are exactly the same, see below
summary(df_filtered$dummy1 == df_filtered$dummy2)

### Question 8.
## Q: How often do you observe a positive value for the diff_price? 

## A:
nrow(df_filtered[(df_filtered$diff_price > 0) , ])

## Q: How often do you observe no price difference between online and offline prices?
## A:
nrow(df_filtered[(df_filtered$diff_price == 0) , ])

### Question 9.
## Q: What is the probability of observing a positive price difference 
## if the good category is Electronics?

## A: we'll call this probability p1 -- answer is .23
## calculation: number of positives differences in Electronics vs all Electronics observations
p1 <- nrow(df_filtered[df_filtered$diff_price = 0 & 
                         df_filtered$category == 'Electronics' , ]) / 
      nrow(df_filtered[df_filtered$category == 'Electronics' , ])

#hist(df_filtered[df_filtered$category == 'Electronics' , 21])

p1

## Q: What is the probability of observing a zero price difference 
## for the category Home and Appliances?

## A: we'll call this probability p2 -- answer is .90
## calculation: number of 0 differences in H&A vs all H&A observations
p2 <- nrow(df_filtered[df_filtered$diff_price == 0 & 
                         df_filtered$category == 'Home and Appliances' , ]) / 
  nrow(df_filtered[df_filtered$category == 'Home and Appliances' , ])

hist(df_filtered[df_filtered$category == 'Home and Appliances' , 21])

p2


### Question 10.
## Q: Create a scatterplot with price and online price
## A:
plot(df_filtered$price, df_filtered$price_online)

## Q: Interpret it. 
## A: Normally the two prices are the same (or very close), with a few outliers.

## Q: Create a scatterplot with price and amazon price. 
## A:
plot(df_filtered$price, df_filtered$price_amazon)

## Q: Interpret it. 
## A: Interestingly there seems to be more difference in prices than in the previous example.
## There are certain very high outliers (where amazon price is bigger) -- it's worth to note that
## in the beginning, we have not removed outliers based on the amazon price, which could
## be an explanation.

## Q: Do you see any between these two scatterplots? What are they telling
## us about the correlation between these variables?
## A: The first scatterplot is closer to expectations (not much difference) than the second.
## We should expect high correlation in the first case, and somewhat lower for the second.
## (actual correlations calculated below for reference)

cor(df_filtered$price, df_filtered$price_online)
cor(df_filtered$price, df_filtered$price_amazon)

### Question 11.


