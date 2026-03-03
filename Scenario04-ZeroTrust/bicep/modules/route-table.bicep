param location string
param firewallPrivateIp string
param spokeSubnets array

resource rt 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-spoke-s04'
  location: location
  properties: {
    routes: [
      {
        name: 'default-to-firewall'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallPrivateIp
        }
      }
    ]
  }
}

@batchSize(1)
resource assoc 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = [for subnetId in spokeSubnets: {
  name: last(split(subnetId, '/subnets/'))
}]

@batchSize(1)
resource assocRt 'Microsoft.Network/virtualNetworks/subnets/routeTables@2023-09-01' = [for (subnetId, i) in spokeSubnets: {
  name: 'assoc-${i}'
  parent: assoc[i]
  properties: {
    routeTable: {
      id: rt.id
    }
  }
}]
