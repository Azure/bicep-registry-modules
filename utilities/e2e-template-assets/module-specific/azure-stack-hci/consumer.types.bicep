@export()
@description('Validated shared dependencies injected by reserved-environment CI. Null retains cold-build fixtures.')
type preparedHciEnvironmentType = {
  customLocationResourceId: string
  vSwitchName: string
  kubernetesVersion: string
}
