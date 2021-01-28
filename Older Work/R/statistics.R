library(Rfast)
library(lpSolve)
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

electoral_winner <- function(my_data)
{
  years <- unique(my_data$year)
  my_data$electoral_winner <- NA
  for (i in 1:length(years))
  {
    year <- years[i]
    results <- electoral_results(year)
    electoral_winner <- results$nominee[which(results$electoral_votes==max(results$electoral_votes))]
    my_data$electoral_winner[which(my_data$year==year)] <- electoral_winner
    
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

compute_electoral_votes <- function(my_data)
{
  my_data$electoral_votes_maximum <- NA
  years <- unique(my_data$year)
  for (i in 1:length(years))
  {
    year <- years[i]
    states <- unique(my_data$state[which(my_data$year==year)])
    for (j in 1:length(states))
    {
      state <- states[j]
      my_data$electoral_votes_maximum[which((my_data$year==year) & (my_data$state==state))] <- 
        sum(my_data$Electoral.vote[which((my_data$year==year) & (my_data$state==state))])
      
    }
  }
  return(my_data)
}

compute_electoral_winner_states <- function(my_data)
{
  my_data$state_winner <- NA
  years <- unique(my_data$year)
  for (i in 1:length(years))
  {
    year <- years[i]
    states <- unique(my_data$state[which(my_data$year==year)])
    for (j in 1:length(states))
    {
      state <- states[j]
      results <- my_data[which((my_data$year==year) & (my_data$state==state)),]
      state_winner <- results$Nominee[which(results$Electoral.vote==max(results$Electoral.vote))]
      my_data$state_winner[which((my_data$year==year) & (my_data$state==state))] <- state_winner
      
    }
    
  }
  return(my_data)
}

compute_votes_needed_to_win <- function(my_data)
{
  my_data$votes_margin_total <- NA
  my_data$votes_margin_total_percentage <- NA
  years <- unique(my_data$year)
  for (i in 1:length(years))
  {
    year = years[i]
    results <- electoral_results(year)
    second <- results$nominee[which(results$electoral_votes==nth(results$electoral_votes,2,descending = TRUE))]
    election_data <- my_data[which(my_data$year==year),]
    election_data <- election_data[which(!duplicated(election_data$state)),]
    useful_data <- election_data[,c("state_winner","state","margin","electoral_votes_maximum","Popular.vote")]
    #sets second places margins to zero (zero cost to flip)
    useful_data[which(useful_data$state_winner==second),]$margin <- 0
    
    
    # Set coefficients of the objective function
    f.obj <- useful_data$margin
    
    # Set matrix corresponding to coefficients of constraints by rows
    
    f.con <- matrix(useful_data$electoral_votes_maximum, nrow = 1, byrow = TRUE)
    
    # Set unequality/equality signs
    f.dir <- c(">=")
    
    # Set right hand side coefficients
    f.rhs <- c(270)
    
    # Final value (z)
    outcome = lp("min", f.obj, f.con, f.dir, f.rhs, int.vec = 1:4, all.bin = TRUE)
    my_data[which(my_data$year==year),]$votes_margin_total <- outcome$objval
    total_votes = sum(my_data[which(my_data$year==year),]$Popular.vote)
    my_data[which(my_data$year==year),]$votes_margin_total_percentage <- (outcome$objval/total_votes)
    
  }
  return(my_data)
}

prez_data <- compute_margins(prez_data)
prez_data <- compute_electoral_votes(prez_data)
prez_data <- electoral_winner(prez_data)
prez_data <- compute_electoral_winner_states(prez_data)
prez_data <- compute_votes_needed_to_win(prez_data)

write.csv(prez_data,"../Data/presidential_elections_since_1920_plots.csv", row.names = FALSE)

write_pivotal_vote_us <- function()
{
  my_data <- prez_data
  years <- unique(my_data$year)
  temp_data <- data.frame(matrix(,ncol=3,nrow=0,byrow = TRUE))
  colnames(temp_data) <- c("party","year","pivotal_vote")
  for (i in 1:length(years))
  {
    year <- years[i]
    parties <- c("Democratic","Republican")
    for (j in 1:length(parties))
    {
      party <- parties[j]
      pivotal_vote <- unique(my_data$votes_margin_total[which(my_data$year==year & my_data$Party == party)])
      new_row <- data.frame(party,year,pivotal_vote)
      colnames(new_row) <- colnames(temp_data)
      temp_data <- rbind(temp_data,new_row)
      
    }
  }
  write.csv(temp_data,"../Data/pivotal_vote_us.csv", row.names = FALSE)
}
