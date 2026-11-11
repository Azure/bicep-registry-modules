
### Parameter Usage: `partitionKeyPaths`, `uniqueKeyPaths`

Different kinds of paths can be provided as array of strings:

<details>

<summary>Bicep format</summary>

```bicep
graphs: [
  {
    name: 'graph01'
    automaticIndexing: true
    partitionKeyPaths: [
      '/name'
    ],

  }
  {
    name: 'graph02'
    automaticIndexing: true
    partitionKeyPaths: [
      '/address'
    ]
  }
]
```

</details>
<p>

