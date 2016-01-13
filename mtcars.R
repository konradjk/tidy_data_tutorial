library(ggplot2)
library(magrittr)
library(dplyr)
library(tidyr)

# tbl_df is a data frame type that won't print the whole data frame to the screen
mtcars %>% tbl_df # tbl_df(mtcars)
mtcars %<>% tbl_df # mtcars = tbl_df(mtcars)

ggplot(mtcars) + geom_point(aes(x=hp, y=mpg), size=3)
ggplot(mtcars) + geom_point(aes(x=hp, y=mpg), size=3) + aes(col=cyl)
ggplot(mtcars) + geom_point(aes(x=hp, y=mpg), size=3) + aes(col=as.factor(cyl))

# plot(lm(mpg ~ hp, mtcars))