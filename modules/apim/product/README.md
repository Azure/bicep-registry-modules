# API Management product

An API Management product for grouping and controlling access to APIs.

## Description

This module defines an API Management product which can be used to group and controlling access to APIs.
Optionally the product can be configured to require approval to subscribe and require a subscription to use.

## Parameters

| Name                   | Type     | Required | Description                                                               |
| :--------------------- | :------: | :------: | :------------------------------------------------------------------------ |
| `name`                 | `string` | No       | A unique name of the product.                                             |
| `displayName`          | `string` | No       | A display name of the product.                                            |
| `description`          | `string` | No       | A description for the product.                                            |
| `serviceId`            | `string` | Yes      | The resource Id to the API Management service.                            |
| `published`            | `bool`   | No       | Determines if the product is published.                                   |
| `approvalRequired`     | `bool`   | No       | Determines if the product requires approval to subscribe.                 |
| `subscriptionRequired` | `bool`   | No       | Determines of the product requires a subscription to use.                 |
| `terms`                | `string` | Yes      | Configures the legal terms to accept prior to subscribing to the product. |
| `groups`               | `array`  | No       | Configures a list of groups that are added to the product.                |

## Outputs

| Name              | Type   | Description                                                                  |
| :---------------- | :----: | :--------------------------------------------------------------------------- |
| name              | string | The name of the API Management Product                                       |
| id                | string | A unique identifier for the API Management Product.                          |
| resourceGroupName | string | The name of the Resource Group where the API Management Product is deployed. |
| subscriptionId    | string | The guid for the subscription where the API Management Product is deployed.  |

## Examples

### Example 1

A basic example of a API Management product which requires subscriptions and is not published by default.

```bicep
@description('A reference to an existing APIM service.')
resource service 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: 'my-apim-service-001'
}

@description('A basic product which requires subscriptions and is not published by default.')
module reporting 'br/public:apim/product:1.0.0' = {
  name: 'reporting-apis'
  params: {
    displayName: 'Reporting'
    description: 'A group of APIs for managing reports.'
    serviceId: service.id
    terms: 'By using this product you agree to the terms of service.'
  }
}
```

### Example 2

An example of a API Management product which requires subscriptions and is automatically published.

```bicep
@description('A reference to an existing APIM service.')
resource service 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: 'my-apim-service-001'
}

@description('A product which requires subscriptions and is automatically published.')
module reporting 'br/public:apim/product:1.0.0' = {
  name: 'reporting-apis'
  params: {
    displayName: 'Reporting'
    description: 'A group of APIs for managing reports.'
    serviceId: service.id
    terms: 'By using this product you agree to the terms of service.'
    published: true
    approvalRequired: true
    subscriptionRequired: true
  }
}
```

### Example 3

An example of a API Management product which automatically grants the `internal-developers` group access to view and subscribe to the product.

```bicep
@description('A reference to an existing APIM service.')
resource service 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: 'my-apim-service-001'
}

@description('A basic product which automatically grants the `internal-developers` group access to view and subscribe to the product.')
module reporting 'br/public:apim/product:1.0.0' = {
  name: 'reporting-apis'
  params: {
    displayName: 'Reporting'
    description: 'A group of APIs for managing reports.'
    serviceId: service.id
    terms: 'By using this product you agree to the terms of service.'
    groups: [
      'internal-developers'
    ]
  }
}
```
