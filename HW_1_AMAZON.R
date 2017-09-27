
## user notes - some lines are commented out with a single '#'
## as it is not needed for solving the exercise, 
## just used for checking results or data understanding


### Question 1.
## Use the amazon_compare.csv file and choose a city to analyze. (Load it into Stata or R)
df <- read.csv('amazon_compare.csv', header = TRUE)

# head(df)
# str(df)
# names(df)

### Question 2.
## Drop observations where price or price online or both are missing. 
# summary(df$price) ## 0 NA values
# summary(df$price_online) ## 1310 NA values
# nrow(df) ##3992 rows in total
# nrow(df[is.na(df$price_online) == FALSE, ]) ## 2682 rows in total where online price is not missing

## creating a new df where NOT both variables are missing
df_filtered = df[!(is.na(df$price_online) | is.na(df$price)), ] 

# nrow(df_filtered) ## checking results ## numbers of rows are 2682 in the new dataset


## Drop observations that are larger than the 99-percentile. 



## How do you call these observations? 
## Make an argument on why should we keep them in the sample. 
## Make another argument on why should we drop them.


### Question 2
