library(haven)
uk_2019 <- read_dta("../Raw Data/BES-2019-General-Election-results-file-v1.0.dta")
uk_2019 <- as.data.frame(uk_2019)
colnames(uk_2019) <- tolower(colnames(uk_2019))

nice_data <- data.frame(matrix(, nrow = 0, ncol = 4))
colnames(nice_data) <- c("constituency","party","votes","year")

for (i in 1:nrow(uk_2019))
{
  row <- uk_2019[i,]
  constituency_name <- row$constituencyname
  party_names_id <- c("con","lab","ld","snp","pc","ukip","green","brexit","other")
  election_years <- c(2019,2017,2015,2010,2005)
  for (j in 1:length(election_years))
  {
    election_year <- election_years[j]
    election_year_id <- substr(election_year,start=3,stop = 4)
    
    for (k in 1:length(party_names_id))
    {
      party_name_id <- party_names_id[k]
      party_vote_column <- paste0(party_name_id,"vote",election_year_id)
      if (party_vote_column %in% colnames(uk_2019))
      {
        votes = row[party_vote_column][[1]]
        
        party_row <- data.frame(constituency_name,party_name_id,votes,election_year)
        colnames(party_row) <- colnames(nice_data)
        nice_data <- rbind(nice_data,party_row)
      }

    }
  }

}

write.csv(nice_data,"../Data/uk_election_data.csv")