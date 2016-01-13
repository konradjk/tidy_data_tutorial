library(dplyr)
library(tidyr)
library(magrittr)
library(broom)

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
messy_data$correlated_test = jitter(messy_data$sat/32, 2000)

messy_data %>% 
  gather(test, score, c(test1, test2, test3, test4, test5, correlated_test))

messy_data %>% 
  gather(test, score, test1:correlated_test)

clean_data = messy_data %>% 
  gather(test, score, test1:correlated_test) %>%
  separate(info, into=c('group', 'sex'), sep='_')

# can proceed with dplyr functions
clean_data %>% sample_n(3) # Sample n entries

clean_data %>% 
  group_by(day) %>% 
  summarize(mean = mean(score), sd = sd(score))
clean_data %>% 
  group_by(sex) %>% 
  summarize(mean = mean(score), sd = sd(score))
clean_data %>% 
  group_by(test) %>% 
  summarize(mean = mean(score), sd = sd(score))

ggplot(clean_data) + geom_point(aes(x = sat, y = score))
ggplot(clean_data) + geom_point(aes(x = sat, y = score, col=test))

clean_data %>%
  group_by(test) %>%
  summarize(correlation = cor(sat, score))

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





