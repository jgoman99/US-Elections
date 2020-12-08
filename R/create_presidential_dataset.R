file_names <- paste0("../Data/presidential_election_states_scraped/",list.files("../Data/presidential_election_states_scraped/"))
for (i in 1:length(file_names))
{
  file_name = file_names[i]
  if (i==1)
  {
    my_data = read.csv(file_name)
  }
  else
  {
    new_data <- read.csv(file_name)
    my_data <- rbind(my_data,new_data)
  }
}

