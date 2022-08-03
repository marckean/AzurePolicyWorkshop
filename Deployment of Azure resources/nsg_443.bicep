param location string = resourceGroup().location

resource nsg2 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
    name: 'nsg_with_443_rules'
    location: location
    properties: {
        securityRules: [ //Rules cannot have the same Priority and Direction
            {
                name: 'Allow_SSL1-S'
                properties: {
                    description: 'Allow RDP'
                    protocol: '*'
                    sourcePortRange: '443'
                    destinationPortRange: '443'
                    sourceAddressPrefix: '*'
                    destinationAddressPrefix: '*'
                    access: 'Allow'
                    priority: 100
                    direction: 'Inbound'
                }
            }
            {
                name: 'Allow_SSL6-D'
                properties: {
                    description: 'Allow RDP'
                    protocol: '*'
                    sourcePortRange: '*'
                    destinationPortRange: '443'
                    sourceAddressPrefix: '*'
                    destinationAddressPrefix: '*'
                    access: 'Allow'
                    priority: 150
                    direction: 'Inbound'
                }
            }
            {
                name: 'Allow_SSL7-D'
                properties: {
                    description: 'Allow RDP'
                    protocol: '*'
                    sourcePortRange: '*'
                    destinationPortRange: '443'
                    sourceAddressPrefix: '164.97.246.192'
                    destinationAddressPrefix: '*'
                    access: 'Allow'
                    priority: 160
                    direction: 'Inbound'
                }
            }
            {
                name: 'Allow_SSL8-D'
                properties: {
                    description: 'Allow RDP'
                    protocol: '*'
                    sourcePortRange: '*'
                    destinationPortRange: '443'
                    sourceAddressPrefix: '164.97.246.192/28'
                    destinationAddressPrefix: '*'
                    access: 'Allow'
                    priority: 170
                    direction: 'Inbound'
                }
            }
        ]
    }
}

output nsg string = nsg2.id
