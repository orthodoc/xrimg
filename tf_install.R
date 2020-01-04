install.packages("tensorflow")
library(tensorflow)
install_tensorflow()
install.packages("keras")
library(keras)
library(tensorflow)
use_implementation("tensorflow")
tfe_enable_eager_execution(device_policy = "silent")
np <- import("numpy")
install.packages("tfdatasets")
install.packages("purrr")
install.packages("stringr")
install.packages("glue")
install.packages("rjson")
install.packages("rlang")
install.packages("dplyr")
install.packages("magick")
library(tfdatasets)
library(purrr)
library(stringr)
library(glue)
library(rjson)
library(rlang)
library(dplyr)
library(magick)

image_model <- application_inception_v3(
  include_top = FALSE,
  weights = "imagenet"
)

load_image <- function(image_path) {
  img <-
    tf$io$read_file(image_path) %>%
    tf$image$decode_jpeg(channels = 3) %>%
    tf$image$resize(c(299L, 299L)) %>%
    tf$keras$applications$inception_v3$preprocess_input()
  list(img, image_path)
}
