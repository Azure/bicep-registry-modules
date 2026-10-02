
### Parameter Usage: `graphs`

List of graph databaseAccounts.

<details>

<summary>Parameter JSON format</summary>

```json
"graphs": {
  "value": [
    {
      "name": "graph01",
      "automaticIndexing": true,
      "partitionKeyPaths": [
        "/name"
      ]
    },
    {
      "name": "graph02",
      "automaticIndexing": true,
      "partitionKeyPaths": [
        "/name"
      ]
    }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
graphs: [
  {
    name: 'graph01'
    automaticIndexing: true
    partitionKeyPaths: [
      '/name'
    ]
  }
  {
    name: 'graph02'
    automaticIndexing: true
    partitionKeyPaths: [
      '/name'
    ]
  }
]
```

</details>

