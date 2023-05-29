/**
 * @param {typeof import("fs").promises} fs
 * @param {string} dir
 */
async function getSubdirNames(fs, dir) {
  var files = await fs.readdir(dir, { withFileTypes: true });
  return files.filter((x) => x.isDirectory()).map((x) => x.name);
}

/**
 * @typedef Params
 * @property {typeof require} require
 * @property {typeof import("@actions/core")} core
 *
 * @param {Params} params
 */
async function generateModuleIndexData({ require, core }) {
  const fs = require("fs").promises;
  const moduleGroups = await getSubdirNames(fs, "modules");

  var moduleIndexData = [];

  const path = require("path");
  const axios = require("axios").default;

  for (const moduleGroup of moduleGroups) {
    var moduleGroupPath = path.join("modules", moduleGroup);
    var moduleNames = await getSubdirNames(fs, moduleGroupPath);

    for (const moduleName of moduleNames) {
      const modulePath = `${moduleGroup}/${moduleName}`;
      const versionListUrl = `https://mcr.microsoft.com/v2/bicep/${modulePath}/tags/list`;

      try {
        core.info(`Getting ${modulePath}...`);

        const versionListResponse = await axios.get(versionListUrl);
        const tags = versionListResponse.data.tags.sort();

        moduleIndexData.push({
          moduleName: modulePath,
          tags: tags,
        });
      } catch (error) {
        core.setFailed(error);
      }
    }
  }

  await fs.writeFile(
    "moduleIndex.json",
    JSON.stringify(moduleIndexData, null, 2)
  );
}

module.exports = generateModuleIndexData;
