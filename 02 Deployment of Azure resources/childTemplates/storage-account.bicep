param location string
param storageAccountNamePrefex string
param minimumTlsVersion string
param supportsHttpsTrafficOnly bool
param allowBlobPublicAccess bool
param storageSku string

resource storageAcct 'Microsoft.Storage/storageAccounts@2021-06-01' = {
    name: '${storageAccountNamePrefex}${uniqueString(resourceGroup().id)}'
    location: location
    sku: {
        name: storageSku
    }
    kind: 'Storage'
    properties: {
        minimumTlsVersion: minimumTlsVersion
        supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
        allowBlobPublicAccess: allowBlobPublicAccess
    }
}

output storageId string = storageAcct.id
