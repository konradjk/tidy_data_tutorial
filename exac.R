library(ggplot2)
library(magrittr)
library(dplyr)
library(tidyr)

observed = get(load(url('http://broadinstitute.org/~konradk/tutorials/tidy_data/observed_variants.RData')))
possible = get(load(url('http://broadinstitute.org/~konradk/tutorials/tidy_data/all_possible_variants.RData')))

observed %>% 
  filter(!is.na(transition)) %>%
  left_join(possible, by=c('consequence', 'cpg', 'transition', 'cutoff')) %>%
  rename(freq.poss = freq.x, freq.obs = freq.y)


# group_by

# plot