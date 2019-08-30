# Custom function to set options for uploading
library(readr)
f <- function(input, output) write_tsv(input, output, append = F, quote_escape = "double", col_names = T)
library(googleCloudStorageR)
library(tidyverse)

