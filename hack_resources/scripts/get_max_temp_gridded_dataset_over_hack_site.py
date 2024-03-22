#Credentials packages
from eratos.creds import AccessTokenCreds
from eratos.adapter import Adapter
import eratos.helpers
import json
import xarray as xr
import eratos_xarray
import numpy as np
import matplotlib.pyplot as plt

###_____________FILL ME IN_____________###
#Path to your creds
creds_path = r"path_to_your_Creds"

###_____________FILL ME IN_____________###
# Opening JSON file
f = open(creds_path)
  
# returns JSON object as 
# a dictionary
creds = json.load(f)

ecreds = AccessTokenCreds(
  creds['key'],
  creds['secret']
)

adapter = Adapter(ecreds)

found_ern = "whatever you can find in the Eratos marketplace"
found_ern = "ern:e-pn.io:resource:eratos.blocks.silo.maxtemperature"

#Printing the dataset once opened will print its metadata
dataset = xr.open_dataset(found_ern, eratos_auth=ecreds)
print(dataset)


lat_range =   (-37.840497, -37.746627)
long_range =  (144.922605, 145.013929)
time_start =  "2024-01-01"
time_end =    "2024-01-08"

bars_region_over_time = dataset.sel(lat=slice(*lat_range), lon=slice(*long_range),time=slice(time_start, time_end))

#Load the subset bars
bars_region_over_time.load()
print(bars_region_over_time)



#Create the plot, note vmin and vmax define the colour grading

#must set variable in dataset will change
bars_region_over_time['max_temp'].plot(x='lon', y='lat', col='time', col_wrap=3)

#Show the plot
plt.show()