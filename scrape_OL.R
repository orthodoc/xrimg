require("rvest")
require("xml2")
require("stringr")
require("tidyverse")
url <- "http://www.orthopaediclist.com/category/implant-identification.html"
ortho.list.page <- read_html(url)

# function to get list of links
get.page.numbers <- function(html) {
  pages.data <- html %>%
    html_nodes("#filter-items-container+ #filter-items-container .page-links-inactive") %>%
    html_text()
  pages.data %>%
    unname() %>%
    as.numeric()
}

page.numbers <- get.page.numbers(ortho.list.page)
# page.numbers <- 30

# function to get offset numbers
get.offset.numbers <- function(pgNumb) {
  (pgNumb - 1) * 30
}

offset.numbers <- get.offset.numbers(page.numbers)
pages <- str_c(url, '?Initial=&searchoffset=', offset.numbers)
list.of.pages <- c(url, pages)

# function to get title
get.title <- function(html) {
  heading <- html %>%
    html_nodes(".ctgy-product-list-box strong") %>%
    html_text() %>%
    str_replace("\\(Implant \\d*\\)", "") %>%
    str_trim() %>%
    unlist()
}

# function to generate UID
generate.uid <- function(html) {
  heading <- html %>%
    html_nodes(".ctgy-product-list-box strong") %>%
    html_text() %>%
    str_extract("\\(.*\\)") %>%
    str_replace("\\(", "") %>%
    str_replace("\\)","") %>%
    str_replace(" ", "") %>%
    str_trim() %>%
    unlist()
}

# function to extract the img url
get.img.url <- function(html) {
  url <- html %>%
    html_nodes(".ctgy-product-list-box img") %>%
    html_attr("src") %>%
    str_trim() %>%
    unlist()
  str_replace(url, "\\.{2}/", "http://orthopaediclist.com/")
}

# function to obatin the data table
get.data.table <- function(html) {
  titles <- get.title(html)
  img.urls <- get.img.url(html)
  uids <- generate.uid(html)
  combined.data <- tibble(uid = uids, title = titles, imgURL = img.urls)
}

get.item.link <- function(html) {
  link_url <- html %>%
    html_nodes('.ctgy-product-list-box-more') %>%
    xml_attr('href') %>%
    unlist()
}

get.img.caption <- function(link_html) {
  text <- link_html %>%
    html_nodes(".product-description-text") %>%
    html_text()
  split_text <- str_split(text, "\\r\\n", n = 2)[[1]]
  caption <- split_text[1] %>%
    str_trim() %>%
    unlist()
}

get.caption.from.link.url <- function(link_url) {
  link_html <- read_html(link_url)
  caption <- get.img.caption(link_html)
}

# function to extract data from the url
get.data.from.url <- function(url) {
  html <- read_html(url)
  table <- get.data.table(html)
  caption <- get.item.link(html) %>%
    map(get.caption.from.link.url) %>% 
    unlist()
  combined_table <- add_column(table, caption)
}

# function to get tsv
write.table <- function(url) {
  list.of.pages %>%
    map(get.data.from.url) %>%
    bind_rows() %>%
    write_tsv("orthoList.tsv")
}
write.table(url)
ortho.list.tbl <- read_tsv("orthoList.tsv")
ortho.list.tbl$imgURL[175] <- "http://orthopaediclist.com/mm5/graphics/00000001/Maxx TKA AP Keegen MD 20140105.png"
ortho.list.tbl$imgURL[182] <- "http://orthopaediclist.com/mm5/graphics/00000001/TKA AP 20150911.jpg"
ortho.list.tbl$imgURL[183] <- "http://orthopaediclist.com/mm5/graphics/00000001/TKA Lat 20150911.jpg"
ortho.list.tbl$imgURL[198] <- "http://orthopaediclist.com/mm5/graphics/00000001/Osteonics HA THA Cooper 20140708.jpg"
ortho.list.tbl$imgURL[376] <- "http://orthopaediclist.com/mm5/graphics/00000001/TibialNailMaimin20180801.jpg"
ortho.list.tbl['impression'] <- NA
ortho.list.tbl['problems']<- NA
write_tsv(ortho.list.tbl, "orthoList.tsv")


ortho.img.list <- read_tsv("orthoList.tsv", col_types = cols(
  uid = col_character(),
  title = col_character(),
  caption = col_character(),
  imgURL = col_character(),
  impression = col_character(),
  problems = col_character()
))
# View(ortho.img.list)
