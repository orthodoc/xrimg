# library(googleAuthR)
library(googleCloudStorageR)
library(googleComputeEngineR)

# set defaults
gce_global_project("vscode-238102")
gce_global_zone("asia-south1-b")
gcs_global_bucket("xray.orthodoc.in")


vm <- gce_vm(
  template = "rstudio",
  name = "rstud",
  username = "bdb",
  password = "bdb2019(",
  predefined_type = "n1-highmem-2",
  disk_size_gb = "100",
  dynamic_image = "gcr.io/gcer-public/persistent-rstudio"
)
gce_set_metadata(list(GCS_SESSION_BUCKET = "xray.orthodoc.in"), vm)

job <- gce_vm_stop("rstud")
job <- gce_vm_start("rstud")
