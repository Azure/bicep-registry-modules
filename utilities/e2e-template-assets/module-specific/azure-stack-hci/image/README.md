# Azure Local host image

`main.json` is the externally consumable subscription-scope template. It creates the image resource group, Compute Gallery, image definition, Image Builder identity and least-privilege role, and the deterministic Image Builder template.

Deploy `main.json`, then dot-source `Invoke-HciImageBuild.ps1` and call `Invoke-HciImageBuild` with the `imageTemplateId` and `imageVersionResourceId` outputs. The function skips an existing successful version, monitors an active run, or starts and verifies a new run.

Delete `rg-avm-persistent-hci-image` to remove all resources created by this asset.
