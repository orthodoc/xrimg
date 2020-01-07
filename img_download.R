library(tidyverse)
library(magick)
# download.file(img.list$imgURL, file.path("img", str_c(img.list$uid, "-", basename(img.list$imgURL))))

# set.filepath <- function(img.list) {
#   filepath <- ifelse(
#     test = str_extract(img.list$imgURL, img.list$uid) == img.list$uid,
#     yes = file.path("img", basename(img.list$imgURL)),
#     no = file.path("img", str_c(img.list$uid, "-", basename(img.list$imgURL)))
#     )
# }

get.img <- function(imgList) {
  id <- str_c(imgList[1], "_", imgList[2])
  # filepath <- ifelse(
  #       test = is.na(str_extract(imgList[3], imgList[1])),
  #       yes = file.path("img", str_c(imgList[1], "-", basename(imgList[3]))),
  #       no = file.path("img", basename(imgList[3]))
  #       )
  filename <- str_c(id, ".png") %>%
    str_trim()
  filepath <- file.path("img", filename)
  save_image <- function(img) {
    image_write(img, filepath)
  }
  imgList[4] %>%
    URLencode() %>%
    image_read() %>%
    image_convert(format = "png") %>%
    save_image()
  
}
apply(img.list, 1, get.img)
