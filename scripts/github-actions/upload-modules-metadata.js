/**
 * @typedef Params
 * @property {typeof require} require
 * @property {typeof import("@actions/core")} core
 *
 * @param {Params} params
 */
async function uploadModulesMetadata({ require, core }) {
  const fs = require("fs");
  const getSubdirNames = require("./scripts/github-actions/get-sub-directory-names.js");
  const moduleGroups = getSubdirNames(fs, "modules");

  var result = [];

  const path = require("path");
  const axios = require("axios").default;

  for (const moduleGroup of moduleGroups) {
    var moduleGroupPath = path.join("modules", moduleGroup);
    var moduleNames = getSubdirNames(fs, moduleGroupPath);

    for (const moduleName of moduleNames) {
      const modulePath = `${moduleGroup}/${moduleName}`;
      const versionListUrl = `https://mcr.microsoft.com/v2/bicep/${modulePath}/tags/list`;

      try {
        core.info(`Getting ${modulePath}...`);

        const versionListResponse = await axios.default.get(versionListUrl);
        const tags = versionListResponse.data.tags.sort();

        result.push({
          moduleName: modulePath,
          tags: tags,
        });
      } catch (error) {
        core.setFailed(error);
      }
    }
  }

  const newModulesMetadata = JSON.stringify(result, null, 2);

  fs.writeFileSync("modulesMetadata.json", newModulesMetadata, (err) => {
    if (err) throw err;
  });
}

module.exports = uploadModulesMetadata;
