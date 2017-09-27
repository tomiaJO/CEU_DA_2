
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
## A: 

## Q: Make another argument on why should we drop them.
## A: 


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
