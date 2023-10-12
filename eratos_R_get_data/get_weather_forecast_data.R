
reticulate::use_condaenv("eratoslabs_R", required=TRUE)
#library(reticulate)
library(rjson)
library(reticulate) 
library(ggplot2)
library(lubridate)
eratosAdapter <- reticulate::import("eratos.adapter")
eratosCreds  <- reticulate::import("eratos.creds")


path_to_eratos_creds = "eratos_creds_template\\o-lab-creds.json"
creds = fromJSON(file = path_to_eratos_creds)

at <- eratosCreds$AccessTokenCreds(creds$key[1], creds$secret[1])
ad <- eratosAdapter$Adapter(at)

# Pull a dataset resource in Eratos via it's unique ern more can be found on the Eratos Marketplace
forecast_rainfall_data = ad$Resource(ern='ern:e-pn.io:resource:eratos.blocks.bom.adfd.3hourlymeanprecipforecastau6km')

# Access the gridded dataset via the Gridded API:
gridded_forecast_rainfall_data = forecast_rainfall_data$data()$gapi()

# Query the Gridded API to see what variables are inside the dataset


# Define the functions input variables following Eratos' data standards
startDate <-  "2023-10-12"
endDate <- "2023-10-18"
# max_temp, as found in the dataset variables
var <- gridded_forecast_rainfall_data$get_key_variables()[1]

# Points in Australia,  Brisbane Convention Centre
#point_list <- list('POINT(153.017955  -27.475874)')
lat = -27.475874
lon = 153.017955

# Key Function
extracted_data = gridded_forecast_rainfall_data$get_point_slices(gridded_forecast_rainfall_data$get_key_variables()[1],'SPP', pts= c(lat,lon) , starts=c(0), ends=c(-1),strides =  c(1))

#print(extracted_data)

timestamps = gridded_forecast_rainfall_data$get_subset_as_array('time')
datetimes <- as.POSIXct(timestamps, origin="1970-01-01", tz="UTC")
datetimes_aest <- with_tz(datetimes, tzone="Australia/Sydney")



df <- data.frame(
  date = datetimes_aest[-1],
  value = extracted_data[-1]
)

ggplot(df, aes(x=date, y=value)) + 
  geom_line() + 
  geom_point() +
  labs(title = "Mean Precipitation Forecast",
       x = "Date",
       y = "Mean Precipitation (mm)") 
#+ 
 # theme_minimal()
