targetScope = 'resourceGroup'

@description('Location for all resources')
param location string = resourceGroup().location

@description('Admin username for VM')
param adminUsername string = 'azureuser'

@secure()
@description('Admin password for VM')
param adminPassword string

module hub 'modules/vnet-hub.bicep' = {
  name: 'hubVnet'
  params: {
    location: location
  }
}

module spoke 'modules/vnet-spoke.bicep' = {
  name: 'spokeVnet'
  params: {
    location: location
    hubVnetId: hub.outputs.vnetId
  }
}

module firewall 'modules/firewall.bicep' = {
  name: 'firewall'
  params: {
    location: location
    hubVnetId: hub.outputs.vnetId
  }
}

module rt 'modules/route-table.bicep' = {
  name: 'routeTable'
  params: {
    location: location
    firewallPrivateIp: firewall.outputs.privateIp
    spokeSubnets: [
      spoke.outputs.subnetAppId
      spoke.outputs.subnetPeWebAppId
    ]
  }
}

module vm 'modules/vm.bicep' = {
  name: 'vm'
  params: {
    location: location
    subnetId: spoke.outputs.subnetAppId
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module app 'modules/app.bicep' = {
  name: 'app'
  params: {
    location: location
  }
}

module data 'modules/data.bicep' = {
  name: 'data'
  params: {
   location: location
  }
}


module dns 'modules/private-dns.bicep' = {
  name: 'dns'
  params: {
    vnetId: spoke.outputs.vnetId
  }
}


module pe 'modules/private-endpoints.bicep' = {
  name: 'privateEndpoints'
  params: {
    location: location
    subnetPeWebAppId: spoke.outputs.subnetPeWebAppId
    subnetAppId: spoke.outputs.subnetAppId
  }
}
