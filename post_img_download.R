source('~/projects/R/xr/xray/utility.R')

if (file.exists("imgList.tsv")) {
  img.list <- read_tsv("imgList.tsv", col_types = cols(
    uid = col_character(),
    title = col_character(),
    caption = col_character(),
    imgURL = col_character(),
    impression = col_character(),
    problems = col_character()
  ))
} else {
  gcs_get_object("imgList.tsv")
  img.list <- read_tsv("imgList.tsv", col_types = cols(
    uid = col_character(),
    title = col_character(),
    caption = col_character(),
    imgURL = col_character(),
    impression = col_character(),
    problems = col_character()
  ))
}

img.list <- img.list %>%
  as_tibble() %>%
  mutate( imgLocal = str_c("img/", id, "_", uid, ".png"))
img.list <- img.list[-c(377),]
write_tsv(img.list, "imgList.tsv")
gcs_upload("imgList.tsv")
