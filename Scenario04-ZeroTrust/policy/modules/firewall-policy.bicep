param location string

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2023-09-01' = {
  name: 'afw-policy-s04'
  location: location
  properties: {
    threatIntelMode: 'Alert' // ili 'Deny' ako želiš stroži režim
  }
}

output policyId string = firewallPolicy.id
