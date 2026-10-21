@secure()
param arbitrary string?

@secure()
param envelope object?

output supplied bool = arbitrary != null || envelope != null
