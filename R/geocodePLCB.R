# geocode liquor licenses from plcb

library(tidyverse)
library(sf)
library(mapview)
library(ggmap)

licenses <- read_csv("~/GitHub/cpln_6890/plcb_licenses/LicenseList.csv")

myKey <- read.table("~/GitHub/google_geocoder.txt", quote="\"", comment.char="")

register_google(key = myKey[1])

# Philly Licenses

licensesPHL <- licenses %>%
  filter(County == "Philadelphia County",
         is.na(`Premises Address`) == FALSE,
         Status != "Expired")

# Do the geocoding - be careful not to run too much at once
geocodedPHL <- geocode(licensesPHL$`Premises Address`, source =  "google")

# cbind the active licenses with lat/lon

geocodedPHL_data <- cbind(licensesPHL, geocodedPHL)

write.csv(geocodedPHL_data, "~/GitHub/cpln_6890/plcb_licenses/PHL_PLCB_geocoded.csv")

licenses_sf <- st_as_sf(geocodedPHL_data %>%
                          filter(is.na(lon) == FALSE),
         coords = c("lon", "lat"), # names of the longitude and latitude columns
         crs = 4326) 

mapview(licenses_sf)

# Try allegheny county

licensesALL <- licenses %>%
  filter(County == "Allegheny County",
         is.na(`Premises Address`) == FALSE,
         Status != "Expired",
         str_detect(`Premises Address`, "PITTSBURGH") == TRUE)

# Do the geocoding - be careful not to run too much at once
geocodedALL <- geocode(licensesALL$`Premises Address`, source =  "google")

# cbind the active licenses with lat/lon

geocodedALL_data <- cbind(licensesALL, geocodedALL)

write.csv(geocodedALL_data, "~/GitHub/cpln_6890/plcb_licenses/ALL_PLCB_geocoded.csv")
