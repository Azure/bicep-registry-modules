async function getModuleMetadata({ require, core }) {
  const fs = require("fs");
  const getSubdirNames = require("./scripts/github-actions/get-sub-directory-names.js");
  const moduleGroups = getSubdirNames("modules");

  var result = [];

  const path = require("path");
  const axios = require("axios").default;

  for (const moduleGroup of moduleGroups) {
    var moduleGroupPath = path.join("modules", moduleGroup);
    var moduleNames = getSubdirNames(moduleGroupPath);

    for (const moduleName of moduleNames) {
      const modulePath = `${moduleGroup}/${moduleName}`;
      const versionListUrl = `https://mcr.microsoft.com/v2/bicep/${modulePath}/tags/list`;
      const moduleRootUrl = `https://github.com/Azure/bicep-registry-modules/tree/main/modules/${modulePath}`;
      const readmeLink = `${moduleRootUrl}/README.md`;

      try {
        const versionListResponse = await axios.default.get(versionListUrl);
        const tags = versionListResponse.data.tags.sort();

        result.push({
          moduleName: modulePath,
          tags: tags,
          readmeLink: readmeLink,
        });
      } catch (error) {
        core.setFailed(error);
      }
    }
  }

  const newModuleMetadata = JSON.stringify(result, null, 2);

  fs.writeFileSync("moduleNamesWithTags.json", newModuleMetadata, (err) => {
    if (err) throw err;
  });
}

module.exports = getModuleMetadata;
