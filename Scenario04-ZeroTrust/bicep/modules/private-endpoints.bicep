param location string
param subnetPeWebAppId string
param subnetAppId string

resource peSql 'Microsoft.Network/privateEndpoints@2023-09-01' = {
  name: 'pe-sql-s04'
  location: location
  properties: {
    subnet: {
      id: subnetAppId
    }
    privateLinkServiceConnections: [
      {
        name: 'sql-s04-connection'
        properties: {
          privateLinkServiceId: resourceId('Microsoft.Sql/servers', 'sql-s04-server')
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
}

resource peStorage 'Microsoft.Network/privateEndpoints@2023-09-01' = {
  name: 'pe-stors04-blob'
  location: location
  properties: {
    subnet: {
      id: subnetAppId
    }
    privateLinkServiceConnections: [
      {
        name: 'stors04-blob-connection'
        properties: {
          privateLinkServiceId: resourceId('Microsoft.Storage/storageAccounts', 'stors04')
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

resource peWeb 'Microsoft.Network/privateEndpoints@2023-09-01' = {
  name: 'subnet-pe-webapp'
  location: location
  properties: {
    subnet: {
      id: subnetPeWebAppId
    }
    privateLinkServiceConnections: [
      {
        name: 'webapp-s04-connection'
        properties: {
          privateLinkServiceId: resourceId('Microsoft.Web/sites', 'webapp-s04')
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
}
