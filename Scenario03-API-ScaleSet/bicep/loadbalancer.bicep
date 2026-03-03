param location string
param subnetId string

resource ilb 'Microsoft.Network/loadBalancers@2023-09-01' = {
  name: 'ilb-api'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'ilbFrontend'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.30.1.4'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'backendPool'
      }
    ]
    probes: [
      {
        name: 'healthProbe'
        properties: {
          protocol: 'Http'
          port: 80
          requestPath: '/'
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]
    loadBalancingRules: [
      {
        name: 'httpRule'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'ilb-api', 'ilbFrontend')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'ilb-api', 'backendPool')
          }
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', 'ilb-api', 'healthProbe')
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
        }
      }
    ]
  }
}

output backendPoolId string = resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'ilb-api', 'backendPool')
