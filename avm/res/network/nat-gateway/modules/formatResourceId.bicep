param generatedResourceIds array = []
param providedResourceIds array = []

output formattedResourceIds array = [for resourceId in concat(generatedResourceIds, providedResourceIds): {
  id: resourceId
}]
