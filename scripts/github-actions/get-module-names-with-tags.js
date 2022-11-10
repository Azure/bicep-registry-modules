/**
 * @param {typeof import("fs")} fs
 * @param {string} dir
 */
function getSubdirNames(fs, dir) {
  return fs
    .readdirSync(dir, { withFileTypes: true })
    .filter((x) => x.isDirectory())
    .map((x) => x.name);
}

async function getModuleNamesWithTags({ require, core }) {
  const fs = require("fs");
  const path = require("path");
  const axios = require("axios").default;

  const moduleGroups = getSubdirNames(fs, "modules");
  const result = [];

  for (const moduleGroup of moduleGroups) {
    var moduleGroupPath = path.join("modules", moduleGroup);
    var moduleNames = getSubdirNames(fs, moduleGroupPath);

    for (const moduleName of moduleNames) {
      const modulePath = `${moduleGroup}/${moduleName}`;
      const versionListUrl = `https://mcr.microsoft.com/v2/bicep/${modulePath}/tags/list`;

      try {
        const versionListResponse = await axios.get(versionListUrl);
        const tags = versionListResponse.data.tags.sort();
        const moduleNameWithTag = new ModuleNameWithTags(moduleName, tags);

        result.push(moduleNameWithTag);
      } catch (error) {
        core.setFailed(error);
      }
    }
  }

  fs.writeFile('moduleNamesWithTags.json', JSON.stringify(result), (err) => {
    if (err) throw err;
   });
}

class ModuleNameWithTags {
  constructor(name, tags) {
    this.name = name;
    this.tags = tags;
  }
}

module.exports = getModuleNamesWithTags;
