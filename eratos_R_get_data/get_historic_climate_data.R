

install.packages('reticulate')

reticulate::install_python(version = '3.9')
reticulate::py_install("https://releases.eratos.com/sdk/python/eratos-python-latest.zip")

eratosAdapter <- reticulate::import("eratos.adapter")

reticulate::use_condaenv("eratoslabs_R", required=TRUE)
#library(reticulate)
library(rjson)
library(reticulate) 
library(ggplot2)
np<-import("numpy")
eratosAdapter <- reticulate::import("eratos.adapter")
eratosCreds  <- reticulate::import("eratos.creds")


path_to_eratos_creds = "eratos_creds_template\\o-lab-creds.json"
creds = fromJSON(file = path_to_eratos_creds)

at <- eratosCreds$AccessTokenCreds(creds$key[1], creds$secret[1])
ad <- eratosAdapter$Adapter(at)

# Pull a dataset resource in Eratos via it's unique ern more can be found on the Eratos Marketplace
max_temperature_data = ad$Resource(ern='ern:e-pn.io:resource:eratos.blocks.silo.maxtemperature')

# Access the gridded dataset via the Gridded API:
gridded_max_temperature_data = max_temperature_data$data()$gapi()

# Query the Gridded API to see what variables are inside the dataset
gridded_max_temperature_data$variables()

# Define the functions input variables following Eratos' data standards
startDate <-  "2022-10-01"
endDate <- "2023-10-01"
# max_temp, as found in the dataset variables
var <- gridded_max_temperature_data$get_key_variables()[1]

# Points in Australia,  Brisbane Convention Centre
point_list <- list('POINT(153.017955  -27.475874)')

# Key Function
extracted_data = gridded_max_temperature_data$get_timeseries_at_points(var, point_list, startDate, endDate)
#print(extracted_data)



df <- data.frame(
  date = seq(as.Date("2022-10-01"), by="day", length.out=365),
  value = extracted_data[-1]
)

ggplot(df, aes(x=date, y=value)) + 
  geom_line() + 
  geom_point() +
  labs(title = "Max Temp Daily over time",
       x = "Date",
       y = "Max Temperature (C)") + 
  theme_minimal()
