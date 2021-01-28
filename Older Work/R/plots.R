library(ggplot2)
library(scales)

plot_data <- read.csv("../Data/presidential_elections_since_1920_plots.csv")
us_pivotal_vote <- read.csv("../Data/pivotal_vote_us.csv")

g1 <- ggplot(plot_data,aes(x=year,y=votes_margin_total, label = electoral_winner)) + geom_point(size=1) + geom_text()
ggsave("../Images/pres_election_by_winning_margin.png",g1,scale = 2)

g2 <- ggplot(plot_data[which(plot_data$votes_margin_total < 1000000),],aes(x=year,y=votes_margin_total, label = electoral_winner)) + geom_point(size=1) + geom_text()
ggsave("../Images/pres_election_by_winning_margin_less_than_a_million_votes.png",g2,scale = 2)

g3 <- ggplot(plot_data[which(plot_data$votes_margin_total < 100000),],aes(x=year,y=votes_margin_total, label = electoral_winner)) + geom_point(size=1) + geom_text()
ggsave("../Images/pres_election_by_winning_margin_less_than_a_100k_votes.png",g3,scale = 2)

g4 <- ggplot(plot_data,aes(x=year,y=votes_margin_total_percentage*100, label = electoral_winner)) + geom_point(size=1) + geom_text()
ggsave("../Images/pres_election_by_winning_margin_pc.png",g4,scale = 2)

g5 <- ggplot(plot_data[which(plot_data$votes_margin_total_percentage < .01),],aes(x=year,y=votes_margin_total_percentage*100, label = electoral_winner)) + geom_point(size=1) + geom_text()
ggsave("../Images/pres_election_by_winning_margin_pct_less_than_1.png",g5,scale = 2)

g6 <- ggplot(us_pivotal_vote,aes(x=year,y=pivotal_vote,fill=factor(party)))+
  geom_bar(stat="identity",position="dodge") + scale_y_continuous(labels = comma)
ggsave("../Images/uspivotalvote.png",g6,scale = 2)

uk_pivotal_vote <- read.csv("../Data/pivotal_vote_uk.csv")
u1 <- ggplot(uk_pivotal_vote[which(uk_pivotal_vote$party!="ld"),],aes(x=year,y=pivotal_vote,fill=factor(party)))+
  geom_bar(stat="identity",position="dodge") + scale_y_continuous(labels = comma)
ggsave("../Images/ukpivotalvote.png",u1)
