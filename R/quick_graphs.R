library(ggplot2)
library(dplyr)
uk_data <- read.csv("../Modified Data/uk_elections.csv")
us_data <- read.csv("../Modified Data/us_elections.csv")


uk_data <- uk_data %>%
  filter(party %in% c("con","lab")) %>% group_by(year) %>% mutate(margin=max(party_votes)-min(party_votes))
uk_plot_data <-uk_data %>% filter(party %in% c("con","lab")) %>%
  filter(pivotal_margin!=0) %>% mutate(pivotal_pct = pivotal_margin/total_votes, normal_margin = margin/total_votes)

us_data <- us_data %>%
  filter(party %in% c("Republican","Democratic")) %>% group_by(year) %>% mutate(margin=max(party_votes)-min(party_votes))
us_plot_data <-us_data %>% filter(party %in% c("Republican","Democratic")) %>%
  filter(pivotal_margin!=0) %>% mutate(pivotal_pct = pivotal_margin/total_votes, normal_margin = margin/total_votes)

uk_plot <- ggplot() + geom_point(data=uk_plot_data,aes(x=year,y=pivotal_pct),shape=2) + 
  geom_point(data=uk_plot_data,aes(x=year,y=normal_margin),shape=3)

us_plot <- ggplot() + geom_point(data=us_plot_data,aes(x=year,y=pivotal_pct),size=2,shape=2) + 
  geom_point(data=us_plot_data,aes(x=year,y=normal_margin),size=2,shape = 3) +
  geom_text(data=us_plot_data,aes(x=year,y=normal_margin,label=round(normal_margin*100,2), group=year,vjust = -0.5,hjust=-.5))+
  geom_text(data=us_plot_data,aes(x=year,y=pivotal_pct,label=round(pivotal_pct*100,2), group=year,vjust = -0.5,hjust=-.5))
