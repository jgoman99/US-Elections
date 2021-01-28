library("rvest")
library(stringr)


scrape_presidential_election_votes_by_url <- function(url_name)
{
  page <- read_html(url_name)
  
  my_text <- page %>% 
    html_nodes(".vevent") %>%
    html_text()
  
  my_text <- str_replace_all(my_text,"\\[a\\]", "\n")
  my_text <- str_replace_all(my_text,"\\[1\\]", "\n")
  my_text <- str_replace_all(my_text,"\\[[1-9]\\]", "\n")
  text_vec <- strsplit(my_text,"\n")[[1]]
  
  # gets rid of blanks 
  text_vec = str_replace_all(text_vec, regex("\\W+"), " ")
  text_vec = text_vec[which(text_vec != "")]
  text_vec = text_vec[which(text_vec != " ")]
  anchors <- c("Nominee","Party","Home state","Running mate","Electoral vote","Popular vote","Percentage")
  
  if (length(which(text_vec=="Home state"))==0)
  {
    anchors <- c("Nominee","Party","Running mate","Electoral vote","Popular vote","Percentage")
  }
  if (url_name == "https://en.wikipedia.org/wiki/1996_United_States_presidential_election_in_Georgia")
  {
    anchors <- c("Nominee","Party","Home state","Running mate","Electoral vote","States carried","Popular vote","Percentage")
  }
  
  
  for (i in 1:(length(anchors)))
  {
    
    start = which(text_vec==anchors[i])[[1]]
    
    if (i>1)
    {
      len_rows = nrow(my_data)
      stop <- start + len_rows + 1
    }
    else
    {
      stop = which(text_vec==anchors[i+1])[[1]]
    }

    row = text_vec[(start+1):(stop-1)]
    row = trimws(row)
    row_data = data.frame(row)
    colnames(row_data) = anchors[i]
    
    if (i == 1)
    {
      my_data = row_data
    }
    else
    {
      my_data = cbind(my_data,row_data)
    }
    
  }
  
  if (length(which(text_vec=="Home state"))==0)
  {
    my_data$`Home state` <- ""
  }
  if (url_name == "https://en.wikipedia.org/wiki/1996_United_States_presidential_election_in_Georgia")
  {
    my_data <- my_data[,c(1:5,7,8)]
  }
  return(my_data)
}

scrape_state <- function(state,start_year,end_year)
{
  years = seq(from=start_year, to = end_year,by=4)
  for (i in 1:length(years))
  {
    year = years[i]
    url_name = paste0("https://en.wikipedia.org/wiki/",year, "_United_States_presidential_election_in_",state)
    print(url_name)
    
    if (i==1)
    {
      my_data = scrape_presidential_election_votes_by_url(url_name)
      my_data$year = year
      my_data$state = state
      my_data$url = url_name
    }
    else
    {
      new_data = scrape_presidential_election_votes_by_url(url_name)
      new_data$year = year
      new_data$state = state
      new_data$url = url_name
      my_data = rbind(my_data, new_data)
    }

  }
  return(my_data)
}

scrape_us_states <- function(start_year,end_year)
{

  states = read.csv("../Data/states.csv")
  for (i in 1:nrow(states))
  {
    state = states$State[i]
    temp_year = start_year
    if (state == "Alaska")
    {
      temp_year = 1960
    }
    else if (state == "Hawaii")
    {
      temp_year = 1960
    }
    
    tryCatch(
      expr = {    
      my_data <- scrape_state(state,temp_year,end_year)
      file_name = paste0("../Data/presidential_election_states_scraped/",state,".csv")
      write.csv(my_data,file_name, row.names = FALSE)
      },
      error = function(e)
      {
        print(paste0("Error at state: ", state))
      }
    )
    


  }
  
}

#2016 is max right now
#georgia,

extract_state <- function(state)
{
  my_data <- scrape_state(state,1920,2016)
  file_name = paste0("../Data/presidential_election_states_scraped/",state,".csv")
  write.csv(my_data,file_name, row.names = FALSE)
}

