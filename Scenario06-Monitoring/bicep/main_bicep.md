## Complete set of Bicep files - Scenario 6:  


## **1. Log Analytics Workspace (law-core-monitoring)**

```bicep
resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'law-core-monitoring'
  location: 'westeurope'
  sku: {
    name: 'PerGB2018'
  }
  properties: {
    retentionInDays: 30
  }
}
```

---

## **2. Data Collection Rule (AMA) + povezivanje na VM**

```bicep
param vmId string

resource dcr 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-vm-core-app'
  location: 'westeurope'
  properties: {
    dataSources: {
      syslog: [
        {
          name: 'syslog-source'
          facilityNames: [
            'auth'
            'authpriv'
            'daemon'
            'kern'
            'syslog'
          ]
          logLevels: [
            'Error'
            'Critical'
            'Alert'
            'Emergency'
          ]
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          name: 'law-dest'
          workspaceResourceId: law.id
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Syslog'
        ]
        destinations: [
          'law-dest'
        ]
      }
    ]
  }
}

resource dcrAssoc 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: 'dcr-assoc-vm-core-app'
  scope: vmId
  properties: {
    dataCollectionRuleId: dcr.id
  }
}
```

---

## **3. Diagnostic Settings (SQL, Storage, Key Vault, NSG)**

### SQL Server

```bicep
param sqlServerId string

resource diagSql 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'ds-sql-core-audit'
  scope: sqlServerId
  properties: {
    workspaceId: law.id
    logs: [
      {
        category: 'SQLSecurityAuditEvents'
        enabled: true
      }
    ]
  }
}
```

### Storage Account

```bicep
param storageId string

resource diagStorage 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'ds-stcore-logs'
  scope: storageId
  properties: {
    workspaceId: law.id
    logs: [
      { category: 'StorageRead', enabled: true }
      { category: 'StorageWrite', enabled: true }
      { category: 'StorageDelete', enabled: true }
    ]
  }
}
```

### Key Vault

```bicep
param keyVaultId string

resource diagKv 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'ds-kv-core-audit'
  scope: keyVaultId
  properties: {
    workspaceId: law.id
    logs: [
      { category: 'AuditEvent', enabled: true }
    ]
  }
}
```

### NSG

```bicep
param nsgId string

resource diagNsg 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'ds-nsg-app-subnet'
  scope: nsgId
  properties: {
    workspaceId: law.id
    logs: [
      { category: 'NetworkSecurityGroupEvent', enabled: true }
      { category: 'NetworkSecurityGroupRuleCounter', enabled: true }
    ]
  }
}
```

---

## **4. Alert Rules (Scheduled Query Alerts v2)**

### Key Vault Forbidden

```bicep
resource alertKvForbidden 'Microsoft.Insights/scheduledQueryRules@2023-03-01-preview' = {
  name: 'alert-kv-forbidden'
  location: 'westeurope'
  properties: {
    description: 'Key Vault forbidden access attempts'
    enabled: true
    source: {
      dataSourceId: law.id
      query: '''
AzureDiagnostics
| where Category == "AuditEvent"
| where StatusCode == 403
'''
    }
    schedule: {
      frequencyInMinutes: 5
      timeWindowInMinutes: 5
    }
    criteria: {
      allOf: [
        {
          query: '''
AzureDiagnostics
| where Category == "AuditEvent"
| where StatusCode == 403
'''
          timeAggregation: 'Count'
          operator: 'GreaterThan'
          threshold: 0
        }
      ]
    }
    severity: 2
  }
}
```

### SQL failed logins

```bicep
resource alertSqlFailed 'Microsoft.Insights/scheduledQueryRules@2023-03-01-preview' = {
  name: 'alert-sql-failed-logins'
  location: 'westeurope'
  properties: {
    enabled: true
    source: {
      dataSourceId: law.id
      query: '''
AzureDiagnostics
| where Category == "SQLSecurityAuditEvents"
| where action_name_s == "DATABASE_AUTHENTICATION_FAILED"
'''
    }
    schedule: {
      frequencyInMinutes: 10
      timeWindowInMinutes: 10
    }
    criteria: {
      allOf: [
        {
          query: '''
AzureDiagnostics
| where Category == "SQLSecurityAuditEvents"
| where action_name_s == "DATABASE_AUTHENTICATION_FAILED"
'''
          timeAggregation: 'Count'
          operator: 'GreaterThan'
          threshold: 5
        }
      ]
    }
    severity: 2
  }
}
```

### Storage delete

```bicep
resource alertStorageDelete 'Microsoft.Insights/scheduledQueryRules@2023-03-01-preview' = {
  name: 'alert-storage-delete'
  location: 'westeurope'
  properties: {
    enabled: true
    source: {
      dataSourceId: law.id
      query: '''
StorageBlobLogs
| where OperationName == "DeleteBlob"
'''
    }
    schedule: {
      frequencyInMinutes: 5
      timeWindowInMinutes: 5
    }
    criteria: {
      allOf: [
        {
          query: '''
StorageBlobLogs
| where OperationName == "DeleteBlob"
'''
          timeAggregation: 'Count'
          operator: 'GreaterThan'
          threshold: 1
        }
      ]
    }
    severity: 2
  }
}
```

### NSG inbound deny

```bicep
resource alertNsgDeny 'Microsoft.Insights/scheduledQueryRules@2023-03-01-preview' = {
  name: 'alert-nsg-inbound-deny'
  location: 'westeurope'
  properties: {
    enabled: true
    source: {
      dataSourceId: law.id
      query: '''
AzureDiagnostics
| where Category == "NetworkSecurityGroupEvent"
| where direction_s == "Inbound"
| where action_s == "Deny"
'''
    }
    schedule: {
      frequencyInMinutes: 10
      timeWindowInMinutes: 10
    }
    criteria: {
      allOf: [
        {
          query: '''
AzureDiagnostics
| where Category == "NetworkSecurityGroupEvent"
| where direction_s == "Inbound"
| where action_s == "Deny"
'''
          timeAggregation: 'Count'
          operator: 'GreaterThan'
          threshold: 50
        }
      ]
    }
    severity: 2
  }
}
```




