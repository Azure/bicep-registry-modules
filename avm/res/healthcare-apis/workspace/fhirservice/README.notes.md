
### Parameter Usage: `acrOciArtifacts`

You can specify multiple Azure Container OCI artifacts using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"acrOciArtifacts": {
    "value": {
        [{
          "digest": "sha256:0a2e01852872580b2c2fea9380ff8d7b637d3928783c55beb3f21a6e58d5d108",
          "imageName": "myimage:v1",
          "loginServer": "myregistry.azurecr.io"
        }]
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
acrOciArtifacts: [
    {
        digest: 'sha256:0a2e01852872580b2c2fea9380ff8d7b637d3928783c55beb3f21a6e58d5d108'
        imageName: 'myimage:v1'
        loginServer: 'myregistry.azurecr.io'
    }
]
```

</details>

<p>

