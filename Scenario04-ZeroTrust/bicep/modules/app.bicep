param location string

resource plan 'Microsoft.Web/serverFarms@2022-09-01' = {
  name: 'ASP-rgs04zerotrust-96a9'
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    capacity: 1
  }
}

resource web 'Microsoft.Web/sites@2022-09-01' = {
  name: 'webapp-s04'
  location: location
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
  }
}
