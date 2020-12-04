library(socviz)
library(ggplot2)

presidential_election_df <- read.csv("../Data/elections_historic_updated_2020.csv")

graph_data <- function(df=presidential_election_df,year_start=1944,year_end=2020,margin=.10,
                       title = "US Presidential Election Margins")
{
  sub_df <- df[which((df$year >= year_start) & (df$year <= year_end)),]
  sub_df <- subset(sub_df,incumbent_john==FALSE)
  g <- ggplot(sub_df,aes(y=popular_margin,x=year, color = win_party, shape = incumbent_john,size=3)) + geom_point() + 
    scale_colour_manual(values = c("Dem." = "#0000FF", "Rep." = "#FF0000")) +
    scale_shape_manual(values = c(0,15)) + 
    scale_x_continuous(breaks = seq(min(df$year), max(df$year), by = 4),1) + 
    geom_hline(yintercept=-margin, linetype="dashed", color = "black") +
    geom_hline(yintercept=margin, linetype="dashed", color = "black") +
    geom_hline(yintercept=0, linetype="solid", color = "black", size=1) + xlab("Year") + ylab("Margin") + 
    ggtitle(title)
  g
}

graph_data()