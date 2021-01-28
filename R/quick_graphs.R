library(ggplot2)

uk_data <- read.csv("../Modified Data/uk_elections.csv")

ggplot() + geom_line(data=uk_data,aes(x=year,y=pivotal.margin,group = party,color = party))