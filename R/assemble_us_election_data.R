dir_path = "../Raw Data/presidential_election_states_scraped/"
files = list.files(dir_path)

us_election_data <- data.frame()
for (i in 1:length(files))
{
  filepath = paste0(dir_path, files[i])
  state_data = read.csv(filepath)
  us_election_data <- rbind(us_election_data,state_data)
}
# converts popular vote to a number
us_election_data$Popular.vote<- gsub(" ","",us_election_data$Popular.vote)
us_election_data$Popular.vote <- as.numeric(us_election_data$Popular.vote)
us_election_data <- us_election_data %>% group_by(state,year) %>% mutate(state_winner_votes=max(Popular.vote))
us_election_data <- us_election_data %>% group_by(state,year) %>% mutate(state_winner=Party[which.max(Popular.vote)])
us_election_data <- us_election_data %>% group_by(state,year) %>% mutate(Electoral.vote=max(Electoral.vote))
#Note may need to reformat data depending on python code for integer programming
us_election_data <- us_election_data %>% select(state,Party,Popular.vote,year,state_winner,state_winner_votes,Electoral.vote)
#write.csv(us_election_data,"../Input Data/us_election_data.csv",row.names = FALSE)