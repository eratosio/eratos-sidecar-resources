#Credentials packages
from eratos.creds import AccessTokenCreds
from eratos.adapter import Adapter
import eratos.helpers
import json
import xarray as xr
import eratos_xarray
import numpy as np
import matplotlib.pyplot as plt
from  eratos_hackathon_helper import *


creds_path = r"path_to_your_Creds"

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


# Download a non-gridded file from a dataset block

dataset_block_ern = "ern:e-pn.io:resource:eratos.blocks.nearmap.aivector"

download_files_for_dataset_block_ern(adapter, dataset_block_ern, destination = '.')

# Download all non-gridded file from a space

space_ern = "ern:e-pn.io:resource:H2RDCXJKHHCTVRPG42QSTABC"

#download_all_non_gridded_files_from_space(adapter, space_ern, destination = '.')