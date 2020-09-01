library(tidyverse)
library(anomalize)
library(stringr)
library(lubridate)
library(aws.s3)
library(tibbletime)


#Load in Our Preprocessed Data
s3load("rdata/preprocess_df.Rdata", bucket = "iiaweb-s3-io-practice-bucket")

df <- as_tbl_time(df, index = timestamp)

#modelop.init
init <- function(df){
anom_df <- df %>% 
  time_decompose(BLAC, method = "stl", frequency = "auto", trend = "auto") %>%
  anomalize(remainder, method = "gesd", alpha = 0.05, max_anoms = 0.2) %>%
  time_recompose() %>%
  filter(anomaly == "Yes")
return(anom_df)
}

#modelop.score
score <- function(anom_df){
  return(nrow(anom_df))
}