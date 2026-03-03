param location string
@secure() 
param sqlAdminPassword string

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'stors04'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: 'sql-s04-server'
  location: 'northeurope'
  properties: {
    administratorLogin: 'sqladminuser'
    administratorLoginPassword: sqlAdminPassword
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
  }
}

@description('SQL database name')
param sqlDbName string = 'db-s04'

resource db 'Microsoft.Sql/servers/databases@2021-11-01' = {
  name: sqlDbName
  parent: sqlServer
  properties: {
    sku: {
      name: 'Basic'
      tier: 'Basic'
    }
  }
}


resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'kv-s04'
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableRbacAuthorization: false
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
  }
}
