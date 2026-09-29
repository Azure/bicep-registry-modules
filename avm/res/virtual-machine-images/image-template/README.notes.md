
### Parameter Usage: `imageSource`

Tag names and tag values can be provided as needed. A tag can be left without a value.

#### Platform Image

<details>

<summary>Parameter JSON format</summary>

```json
"source": {
    "type": "PlatformImage",
    "publisher": "MicrosoftWindowsDesktop",
    "offer": "Windows-10",
    "sku": "19h2-evd",
    "version": "latest"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
source: {
    type: 'PlatformImage'
    publisher: 'MicrosoftWindowsDesktop'
    offer: 'Windows-10'
    sku: '19h2-evd'
    version: 'latest'
}
```

</details>
<p>

#### Managed Image

<details>

<summary>Parameter JSON format</summary>

```json
"source": {
    "type": "ManagedImage",
    "imageId": "/subscriptions/<subscriptionId>/resourceGroups/{destinationResourceGroupName}/providers/Microsoft.Compute/images/<imageName>"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
source: {
    type: 'ManagedImage'
    imageId: '/subscriptions/<subscriptionId>/resourceGroups/{destinationResourceGroupName}/providers/Microsoft.Compute/images/<imageName>'
}
```

</details>
<p>

#### Shared Image

<details>

<summary>Parameter JSON format</summary>

```json
"source": {
    "type": "SharedImageVersion",
    "imageVersionID": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>/providers/Microsoft.Compute/galleries/<sharedImageGalleryName>/images/<imageDefinitionName/versions/<imageVersion>"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
source: {
    type: 'SharedImageVersion'
    imageVersionID: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>/providers/Microsoft.Compute/galleries/<sharedImageGalleryName>/images/<imageDefinitionName/versions/<imageVersion>'
}
```

</details>
<p>

