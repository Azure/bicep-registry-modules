# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/azd/container-app-upsert/CHANGELOG.md).

## 0.4.0

### Changes

- Add new `volumes` parameter to define volumes that can be mounted by containers in the container app
- Add new `volumeMounts` parameter to configure volume mounts for the primary container
- Bump `acr-container-app` module reference from `0.2.0` to `0.5.0`

### Breaking Changes

- None

## 0.3.0

### Changes

- Add new `allowedOrigins` param to configure allowed origins

### Breaking Changes

- None

## 0.2.0

### Changes

- Add new `containerProbes` param to configure probes
- Update underlying AVM and resource API versions

### Breaking Changes

- Update `secrets` parameter type from `object` to `secretType[]?`

## 0.1.2

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
