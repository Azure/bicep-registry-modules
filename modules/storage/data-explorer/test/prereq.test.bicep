// param location string

// module eventhub 'br/public:data/event-hub:0.0.1' = {
//   name: 'myeventhub'
//   params: {
//     location: location
//   }
// }

// module cosmosdb 'br/public:database/cosmosdb:0.0.1' = {
//   name: 'mycosmosdb'
//   params: {
//     location: location
//   }
// }

// output eventHubNamespaceName string = eventhub.outputs.namespaceName
// output eventHubName string = eventhub.outputs.name
// output cosmosDBAccountName string = comosdb.outputs.name
