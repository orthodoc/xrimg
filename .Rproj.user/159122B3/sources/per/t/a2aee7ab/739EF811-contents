source('~/projects/R/xr/xray/scrape_OL.R')
ortho.img.list <- read_tsv("orthoList.tsv")

source('~/projects/R/xr/xray/scrape_medpix.R')
nih.img.list <- read_tsv("nihImgList.tsv")

img.list <- full_join(ortho.img.list, nih.img.list) %>%
  write_tsv("imgList.tsv")