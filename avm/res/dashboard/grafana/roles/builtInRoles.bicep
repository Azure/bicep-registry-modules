@export()
var builtInRoleNames = {
  'Monitoring Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
  )
  'Grafana Admin': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '22926164-76b3-42b3-bc55-97df8dab3e41'
  )
  'Grafana Editor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a79a5197-3a5c-4973-a920-486035ffd60f'
  )
  'Grafana Viewer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '60921a7e-fef1-4a43-9b16-a26c52ad4769'
  )
}
