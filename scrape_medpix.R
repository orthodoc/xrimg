require(tidyverse)
require(httr)
require(xml2)
require(jsonlite)
require(rvest)

# url : https://openi.nlm.nih.gov/gridquery?it=xg,xm,x&m=1&n=100

#total.images <- 46837 : xg,xm,x
#total.images <- 124913 # xg,xm,x,u,p,m,c
total.images <- 124913
#total.images <- 124
imgs.per.page <- 100
start.num <- 1
m <- seq(from=start.num, to=total.images, by=imgs.per.page)
# n <- seq(from=imgs.per.page, to=total.images, by=imgs.per.page)
n <- seq(from=(start.num + imgs.per.page -1), to=total.images, by=imgs.per.page)
if (length(m) > length(n)) {
  n <- append(n, total.images, after = length(n))
}
mn.df <- data.frame(m, n)
query.url <- "https://openi.nlm.nih.gov/api/search?it=xg,xm,x,u,p,m,c&"
pages <- str_c(query.url, 'm=', mn.df$m,'&n=', mn.df$n)

get.data.from.url <- function(path) {
  request <- GET(url = path)
  img.df <- request %>%
    content(as = "text", encoding = "UTF-8") %>%
    fromJSON(flatten = TRUE) %>%
    discard(is_empty) %>%
    map_if(is.data.frame, list) %>%
    as_tibble() %>%
    unnest(cols = c(list))
}

clean.data <- function(img.df) {
  img.df$MeSH.major <- NULL
  img.df$MeSH.minor <- NULL
  img.df$imgLarge <- str_c("https://openi.nlm.nih.gov",img.df$imgLarge)
  img.df$title <- ifelse(test = is_empty(img.df$title), yes = NA, no = img.df$title)
  img.df$image.caption <- ifelse(test = img.df$image.caption == "Not Available.", yes = NA, no = img.df$image.caption)
  img.df$impression <- ifelse(test =  ("impression" %in% colnames(img.df) && !is_empty(img.df$impression)), yes = img.df$impression, no = NA)
  img.df$Problems <- ifelse(test = ("Problems" %in% colnames(img.df) && !is_empty(img.df$Problems)), yes = img.df$Problems, no = NA)
  img.df %>%
    select(uid,title, caption = image.caption, imgURL = imgLarge, impression, problems = Problems) %>%
    mutate_all(as.character)
}

get.clean.data <- function(path) {
  path %>%
    get.data.from.url %>%
    clean.data
}

write.table <- function() {
  pages %>%
    map(get.clean.data) %>%
    bind_rows() %>%
    write_tsv('nihImgList.tsv')
}
write.table()
nih.img.list <- read_tsv("nihImgList.tsv", col_types = cols(
  uid = col_character(),
  title = col_character(),
  caption = col_character(),
  imgURL = col_character(),
  impression = col_character(),
  problems = col_character()
))
# View(nih.img.list)

