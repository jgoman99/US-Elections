library(Rfast)
prez_data <- read.csv("../Data/presidential_elections_since_1920.csv")
prez_data$Electoral.vote <- as.numeric(prez_data$Electoral.vote)
prez_data$Popular.vote <- as.numeric(prez_data$Popular.vote)
prez_data$Percentage <- as.numeric(prez_data$Percentage)
electoral_results <- function(year)
{
  year_data <- prez_data[which(prez_data$year==year),]
  
  nominees <- unique(year_data$Nominee)
  my_data <- data.frame()
  for (i in 1:length(nominees))
  {
    nominee <- nominees[i]
    electoral_votes <- sum(year_data$Electoral.vote[which(year_data$Nominee==nominee)])
    row <- data.frame(nominee,electoral_votes)
    colnames(row)
    my_data <- rbind(my_data,row)
  }
  return(my_data)
  
}

compute_margins <- function(my_data)
{
  my_data$margin <- NA
  years <- unique(my_data$year)
  for (i in 1:length(years))
  {
    year <- years[i]
    states <- unique(my_data$state[which(my_data$year==year)])
    for (j in 1:length(states))
    {
      state <- states[j]
      my_data$margin[which((my_data$year==year) & (my_data$state==state))] <- 
        nth(my_data$Popular.vote[which((my_data$year==year) & (my_data$state==state))],1, descending = TRUE) - 
        nth(my_data$Popular.vote[which((my_data$year==year) & (my_data$state==state))],2, descending = TRUE)
      
    }
  }
  return(my_data)
}

prez_data <- compute_margins(prez_data)