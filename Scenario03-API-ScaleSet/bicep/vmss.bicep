param location string
param adminUsername string
@secure()
param adminPassword string
param subnetId string
param backendPoolId string

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2024-03-01' = {
  name: 'vmss-api'
  location: location
  sku: {
    name: 'Standard_B2s'
    tier: 'Standard'
    capacity: 1
  }
  properties: {
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      storageProfile: {
        imageReference: {
          publisher: 'Canonical'
          offer: '0001-com-ubuntu-server-noble'
          sku: '24_04-lts'
          version: 'latest'
        }
      }
      osProfile: {
        computerNamePrefix: 'vmss-api'
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'nicConfig'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: 'ipconfig1'
                  properties: {
                    subnet: {
                      id: subnetId
                    }
                    loadBalancerBackendAddressPools: [
                      {
                        id: backendPoolId
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
      extensionProfile: {
        extensions: [
          {
            name: 'CustomScript'
            properties: {
              publisher: 'Microsoft.Azure.Extensions'
              type: 'CustomScript'
              typeHandlerVersion: '2.1'
              autoUpgradeMinorVersion: true
              settings: {
                commandToExecute: 'bash -c "sudo apt-get update && sudo apt-get install -y nginx && echo API instance running on $(hostname) | sudo tee /var/www/html/index.html && sudo systemctl enable nginx && sudo systemctl restart nginx"'
              }
            }
          }
        ]
      }
    }
  }
}

output vmssId string = vmss.id
