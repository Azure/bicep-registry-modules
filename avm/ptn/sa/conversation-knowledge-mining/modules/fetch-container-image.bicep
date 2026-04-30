param exists bool
param name string

resource existingApp 'Microsoft.App/containerApps@2026-01-01' existing = if (exists) {
  name: name
}

output containers array = exists ? existingApp.properties.template.containers : []
