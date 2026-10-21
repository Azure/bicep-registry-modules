@minLength(1)
type nameSeed = string

@minValue(2)
type maximumNameLength = int

@export()
@description('Preserves a valid base-name prefix and adds a stable scope-specific suffix within the supplied length limit. Include the subscription in scopeId.')
func uniqueResourceName(baseName nameSeed, scopeId nameSeed, maxLength maximumNameLength) string =>
  '${take(baseName, max(1, maxLength - 13))}${take(uniqueString(scopeId, baseName), min(13, maxLength - 1))}'
