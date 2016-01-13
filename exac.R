library(ggplot2)
library(magrittr)
library(dplyr)
library(tidyr)

# Load all observed and possible variants from ExAC
observed = get(load(url('http://broadinstitute.org/~konradk/tutorials/tidy_data/observed_variants.RData')))
possible = get(load(url('http://broadinstitute.org/~konradk/tutorials/tidy_data/all_possible_variants.RData')))

# Join the two datasets and filter, piping all the way to a plot
observed %>% 
  filter(!is.na(transition)) %>%
  left_join(possible, by=c('consequence', 'cpg', 'transition', 'cutoff')) %>%
  rename(freq.obs = freq.x, freq.poss = freq.y) %>%
  filter(cutoff == 0.8) %>%
  mutate(obs_poss = freq.obs/freq.poss) %>%
  filter(!is.na(obs_poss) & transition) %>%
  select(-cutoff) %>%
  ggplot + geom_bar(aes(x = consequence, y = obs_poss, fill=cpg), stat='identity', position='dodge')

