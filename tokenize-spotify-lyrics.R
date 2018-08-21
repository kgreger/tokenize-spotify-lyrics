## load necessary libraries
library(dplyr)
library(tidytext)
setwd("~/GitHub/tokenize-spotify-lyrics/")


## load lyrics file
lyrics <- read.csv("spotify-lyrics.csv", 
                   stringsAsFactors = FALSE)


## prepare sentiment dictionary
afinn <- get_sentiments("afinn")


## prepare stopword dictionary
stop_words <- stop_words %>% 
  group_by(word) %>% 
  summarize() %>% 
  mutate(stopword = TRUE)


## tokenize lyrics for text analysis
token <- lyrics %>% 
  unnest_tokens(word, 
                lyrics) %>% 
  # remove unnecessary columns
  select(song_id, word)


## extract and process unique tokens
token_unique <- token %>% 
  # extract words only
  select(word) %>% 
  # boil down to unique words
  unique() %>% 
  # add sentiment
  left_join(afinn, 
            by = "word") %>% 
  # add stopword classifier
  left_join(stop_words, 
            by = "word")

## join tokens with unique tokens' sentiment & stopword flag
token <- token %>% 
  left_join(token_unique, 
            by = "word")

## export tokenized version of lyrics
write.table(token, 
            file = "spotify-lyrics-tokenized.csv", 
            append = FALSE, 
            sep = ";", 
            row.names = FALSE)
