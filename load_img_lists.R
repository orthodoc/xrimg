source('~/projects/R/xr/xray/utility.R')

# load the ortho list of implants
get.ortho.list <- function() {
  if (file.exists("orthoList.tsv")) {
    ortho.img.list <- read_tsv("orthoList.tsv")
  } else {
    if ("orthoList.tsv" %in% gcs_list_objects()$name) {
      gcs_get_object("orthoList.tsv", saveToDisk = "orthoList.tsv")
      ortho.img.list <- read_tsv("orthoList.tsv")
    } else {
      source('~/xrimg/scrape_OL.R')
      gcs_upload("orthoList.tsv")
    }
  }
}

# Load the NIH list of medical images
get.nih.list <- function() {
  if (file.exists("nihImgList.tsv")) {
    nih.img.list <- read_tsv("nihImgList.tsv")
  } else {
    if ("nihImgList.tsv" %in% gcs_list_objects()$name) {
      gcs_get_object("nihImgList.tsv", saveToDisk = "nihImgList.tsv")
      nih.img.list <- read_tsv("nihImgList.tsv")
    } else {
      source('~/xrimg/scrape_medpix.R')
      gcs_upload("nihImgList.tsv")
    }
  }
}

#load the final img list
get.img.list <- function() {
  if (file.exists("imgList.tsv")) {
    img.list <- read_tsv("imgList.tsv")
  } else {
    ortho.img.list <- get.ortho.list()
    nih.img.list <- get.nih.list()
    img.list <- full_join(ortho.img.list, nih.img.list) %>%
      rowid_to_column("id") %>%
      write_tsv("imgList.tsv")
  }
}

if (file.exists("imgList.tsv")) {
  gcs_upload("imgList.tsv")
}

img.list <- get.img.list()

