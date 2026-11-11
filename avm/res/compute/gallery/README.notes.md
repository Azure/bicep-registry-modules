
Currently it is not possible to redeploy the `image.diskControllerType` property with a value of `NVMe, SCSI`. The initial deployment is working, but other deployments will result in an error.

```json
"details": [
    {
      "code": "PropertyChangeNotAllowed",
      "target": "DiskControllerTypes",
      "message": "Changing property 'DiskControllerTypes' is not allowed."
    }
  ]
```

Once this bug has been resolved, the max test will be updated to deploy an image with the property value.

