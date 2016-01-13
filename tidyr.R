library(dplyr)
library(tidyr)
library(magrittr)
library(ggplot2)

# Random dataset of SAT scores and 5 random tests with random groups
set.seed(1)
points = 100
messy_data <- tbl_df(data.frame(
  individual = 1:points,
  info = c(rep("group1_male", points/4), rep("group1_female", points/4), rep("group2_male", points/4), rep("group2_female", points/4)),
  sat = rnorm(n = points, mean = 1600, sd = 200),
  test1 = rnorm(n = points, mean = 70, sd = 10),
  test2 = rnorm(n = points, mean = 60, sd = 20),
  test3 = rnorm(n = points, mean = 80, sd = 5),
  test4 = rnorm(n = points, mean = 90, sd = 1),
  test5 = rnorm(n = points, mean = 50, sd = 30)
))
# Creating a correlated metric
messy_data$correlated_test = jitter(messy_data$sat/32, 2000)

# Various ways to convert from wide to long
messy_data %>% 
  gather(test, score, c(test1, test2, test3, test4, test5, correlated_test))
messy_data %>% 
  gather(test, score, test1:correlated_test)
messy_data %>% 
  gather(test, score, contains('test'))

clean_data = messy_data %>% 
  gather(test, score, test1:correlated_test) %>%
  separate(info, into=c('group', 'sex'), sep='_')

# dplyr functions
clean_data %>% filter(group == 'group2')
clean_data %>% sample_n(3) # Sample n entries

# Group by creates groups that you can summarize nicely
clean_data %>% 
  group_by(sex) %>% 
  summarize(mean = mean(score), sd = sd(score))
clean_data %>% 
  group_by(test) %>% 
  summarize(mean = mean(score), sd = sd(score))

# Finding the correlated test
ggplot(clean_data) + geom_point(aes(x = sat, y = score), size = 3)
ggplot(clean_data) + geom_point(aes(x = sat, y = score, col=test), size = 3)

# Can spot it easily with group_by and then summarize(cor)
clean_data %>%
  group_by(test) %>%
  summarize(correlation = cor(sat, score))

# ...or use linear models!
library(broom)
clean_data %>%
  group_by(test) %>%
  do(tidy(lm(score ~ sat, data = .)))

# Other methods: augument, glance
all_fits = clean_data %>%
  group_by(test) %>%
  do(fit = lm(score ~ sat, data = .))

all_fits %>% tidy(fit)
all_fits %>% augment(fit)
all_fits %>% glance(fit)


clean_data$test %<>% as.character # Sending pipe contents back and storing them
# Equivalent to clean_data$test = as.character(clean_data$test)
  
  
  