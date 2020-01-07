# Generating .httr-oauth for authenticating to google api
# library(googlesheets)
# library(httr)
# 
# 
# gen.token <- function() {
#   file.remove('.httr-oauth')
#   
#   oauth2.0_token(
#     endpoint = oauth_endpoints("google"),
#     app = oauth_app(
#       "google", 
#       key = getOption("googlesheets.client_id"), 
#       secret = getOption("googlesheets.client_secret")
#     ),
#     scope = c(
#       "https://spreadsheets.google.com/feeds", 
#       "https://www.googleapis.com/auth/drive"),
#     use_oob = TRUE,
#     cache = TRUE
#   )
# }
# 
# gen.token()

.onAttach <- function(libname, pkgname) {
  googleAuthR::gar_attach_auto_auth("https://www.googleapis.com/auth/devstorage.full_control",
                                    environment_var = "GCS_AUTH_FILE")
}
