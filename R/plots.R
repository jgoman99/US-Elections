library(ggplot2)
plot_data <- read.csv("../Data/presidential_elections_since_1920_plots.csv")

g1 <- ggplot(plot_data,aes(x=year,y=votes_margin_total, label = electoral_winner)) + geom_point(size=1) + geom_text()
ggsave("../Images/pres_election_by_winning_margin.png",g1,scale = 2)

g2 <- ggplot(plot_data[which(plot_data$votes_margin_total < 1000000),],aes(x=year,y=votes_margin_total, label = electoral_winner)) + geom_point(size=1) + geom_text()
ggsave("../Images/pres_election_by_winning_margin_less_than_a_million_votes.png",g2,scale = 2)

g3 <- ggplot(plot_data[which(plot_data$votes_margin_total < 100000),],aes(x=year,y=votes_margin_total, label = electoral_winner)) + geom_point(size=1) + geom_text()
ggsave("../Images/pres_election_by_winning_margin_less_than_a_100k_votes.png",g3,scale = 2)
