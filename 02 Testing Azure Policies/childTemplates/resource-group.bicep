targetScope = 'subscription'

param RG_name string
param location string

resource RG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: RG_name
  location: location
}

output RGLocation string = RG.location
output RGName string = RG.name
