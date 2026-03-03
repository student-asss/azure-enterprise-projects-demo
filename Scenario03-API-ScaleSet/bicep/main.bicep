param location string = resourceGroup().location
param adminUsername string = 'azureuser'
@secure()
param adminPassword string

module network 'network.bicep' = {
  name: 'network'
  params: {
    location: location
  }
}

module lb 'loadbalancer.bicep' = {
  name: 'loadbalancer'
  params: {
    location: location
    subnetId: network.outputs.backendSubnetId
  }
}

module vmss 'vmss.bicep' = {
  name: 'vmss'
  params: {
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
    subnetId: network.outputs.backendSubnetId
    backendPoolId: lb.outputs.backendPoolId
  }
}

module autoscale 'autoscale.bicep' = {
  name: 'autoscale'
  params: {
    location: location
    vmssId: vmss.outputs.vmssId
  }
}
