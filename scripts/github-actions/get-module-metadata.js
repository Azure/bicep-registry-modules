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

async function getModuleMetadata({ require, github, context, core }) {
  const fs = require("fs");
  const path = require("path");
  const axios = require("axios").default;
  const createPR = require("create-pull-request-helper.js");

  const moduleGroups = getSubdirNames(fs, "modules");
  var result = {};

  for (const moduleGroup of moduleGroups) {
    var moduleGroupPath = path.join("modules", moduleGroup);
    var moduleNames = getSubdirNames(fs, moduleGroupPath);

    for (const moduleName of moduleNames) {
      const modulePath = `${moduleGroup}/${moduleName}`;
      const versionListUrl = `https://mcr.microsoft.com/v2/bicep/${modulePath}/tags/list`;

      try {
        const versionListResponse = await axios.default.get(versionListUrl);
        const tags = versionListResponse.data.tags.sort();

        result[modulePath] = tags;
      } catch (error) {
        core.setFailed(error);
      }
    }
  }

  const oldModuleMetadata = fs.readFileSync("moduleMetadata.json", {
    encoding: "utf-8",
  });
  const newModuleMetadata = JSON.stringify(result, null, 2);

  if (oldModuleMetadata === newModuleMetadata) {
    core.info("The module names with tags information is up to date.");
    return;
  }

  const prUrl = await createPR.createPullRequest(
    "dev/bhsubra/CreateBicepRegistryModuleReferences", 
    "refresh-module-metadata",
    newModuleMetadata,
    context,
    github,
    "Refresh module metadata",
    "moduleMetadata.json",
    "Refresh bicep registry module references"
    );

  core.info(
    `The module metadata is outdated. A pull request ${prUrl} was created to update it.`
  );
}

module.exports = getModuleMetadata;
