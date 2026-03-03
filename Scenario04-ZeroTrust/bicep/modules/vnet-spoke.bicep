param location string
param hubVnetId string

resource vnetSpoke 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-spoke-s04'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.45.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet-app'
        properties: {
          addressPrefix: '10.45.1.0/24'
        }
      }
      {
        name: 'subnet-app-wapp'
        properties: {
          addressPrefix: '10.45.0.0/24'
        }
      }
      {
        name: 'subnet-pe-webapp'
        properties: {
          addressPrefix: '10.45.2.0/24'
        }
      }
    ]
  }
}

output vnetId string = vnetSpoke.id
output subnetAppId string = vnetSpoke.properties.subnets[0].id
output subnetAppWappId string = vnetSpoke.properties.subnets[1].id
output subnetPeWebAppId string = vnetSpoke.properties.subnets[2].id
