param location string

resource vnetHub 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-hub-s04'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.40.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.40.1.0/24'
        }
      }
    ]
  }
}

output vnetId string = vnetHub.id
