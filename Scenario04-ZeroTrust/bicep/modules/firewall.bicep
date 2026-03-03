param location string
param hubVnetId string

resource pip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'pip-afw-hub-s04'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource policy 'Microsoft.Network/firewallPolicies@2023-09-01' = {
  name: 'afw-policy-s04'
  location: location
  properties: {}
}

resource afw 'Microsoft.Network/azureFirewalls@2023-09-01' = {
  name: 'afw-hub-s04'
  location: location
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    firewallPolicy: {
      id: policy.id
    }
    ipConfigurations: [
      {
        name: 'afw-ipconfig'
        properties: {
          subnet: {
            id: '${hubVnetId}/subnets/AzureFirewallSubnet'
          }
          publicIPAddress: {
            id: pip.id
          }
        }
      }
    ]
  }
}

output privateIp string = afw.properties.ipConfigurations[0].properties.privateIPAddress
