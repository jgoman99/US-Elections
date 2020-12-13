library(lpSolve)

uk_elections <- read.csv("../Data/uk_election_data.csv")
uk_elections$votes[which(is.na(uk_elections$votes))]<-0


calc_seat_winner_and_votes <- function(my_data)
{
  my_data$seat_winner <- NA 
  my_data$seat_winner_votes <- NA 
  
  years <- unique(my_data$year)
  
  for (i in 1:length(years))
  {
    year <- years[i]
    seats <- unique(my_data[which(my_data$year==year),]$seat)
    for (j in 1:length(seats))
    {
      seat <- seats[j]
      seat_data <- my_data[which(my_data$year==year & my_data$seat == seat),]
      seat_winner_votes = max(seat_data$votes, na.rm = TRUE)
      seat_winner <- seat_data[which(seat_data$votes==seat_winner_votes),]$party
      my_data[which(my_data$year==year & my_data$seat == seat),]$seat_winner_votes <- seat_winner_votes
      my_data[which(my_data$year==year & my_data$seat == seat),]$seat_winner <- seat_winner
    }
  }
  return(my_data)
}

uk_elections <- calc_seat_winner_and_votes(uk_elections)

calc_pivotal_vote <- function(party,year)
{
  year_data <- uk_elections[which(uk_elections$year==year & uk_elections$party==party),]
  year_data$margin <- year_data$seat_winner_votes-year_data$votes
  
  # Set coefficients of the objective function
  f.obj <- year_data$margin
  
  # Set matrix corresponding to coefficients of constraints by rows
  
  f.con <- matrix(1, ncol = 632, byrow = TRUE)
  
  # Set unequality/equality signs
  f.dir <- c(">=")
  
  # Set right hand side coefficients
  f.rhs <- c(326)
  
  # Final value (z)
  outcome = lp("min", f.obj, f.con, f.dir, f.rhs, int.vec = 1:4, all.bin = TRUE)
  return(outcome$objval)
  
}

write_pivotal_vote_uk <- function()
{
  my_data <- uk_elections
  years <- unique(uk_elections$year)
  temp_data <- data.frame(matrix(,ncol=3,nrow=0,byrow = TRUE))
  colnames(temp_data) <- c("party","year","pivotal_vote")
  for (i in 1:length(years))
  {
    year <- years[i]
    parties <- c("con","lab","ld")
    for (j in 1:length(parties))
    {
      party <- parties[j]
      pivotal_vote <- calc_pivotal_vote(party,year)
      new_row <- data.frame(party,year,pivotal_vote)
      colnames(new_row) <- colnames(temp_data)
      temp_data <- rbind(temp_data,new_row)
      
    }
  }
  write.csv(temp_data,"../Data/pivotal_vote_uk.csv", row.names = FALSE)
}

