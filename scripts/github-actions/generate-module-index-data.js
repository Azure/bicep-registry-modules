/**
 * @param {typeof import("fs").promises} fs
 * @param {string} dir
 */
async function getSubdirNames(fs, dir) {
  var files = await fs.readdir(dir, { withFileTypes: true });
  return files.filter((x) => x.isDirectory()).map((x) => x.name);
}

async function getModuleDescription(
  github,
  core,
  path,
  modulePath,
  tag,
  context
) {
  // Retrieve the main.json file as it existed for the given tag
  const ref = `tags/${modulePath}/${tag}`;
  core.info(`  Retrieving main.json at ref ${ref}`);
  const mainJsonPath = path
    .join("modules", modulePath, "main.json")
    .replace(/\\/g, "/");

  const response = await github.rest.repos.getContent({
    owner: context.repo.owner,
    repo: context.repo.repo,
    path: mainJsonPath,
    ref,
  });

  if (response.data.type === "file") {
    const content = Buffer.from(response.data.content, "base64").toString();
    const json = JSON.parse(content);
    return json.metadata.description;
  } else {
    throw new Error("The specified path does not represent a file.");
  }
}

/**
 * @typedef Params
 * @property {typeof require} require
 * @property {ReturnType<typeof import("@actions/github").getOctokit>} github
 * @property {typeof import("@actions/github").context} context
 * @property {typeof import("@actions/core")} core
 *
 * @param {Params} params
 */
async function generateModuleIndexData({ require, github, context, core }) {
  const fs = require("fs").promises;
  const path = require("path");
  const axios = require("axios").default;
  const moduleGroups = await getSubdirNames(fs, "modules");
  const modulesWithDescriptions = new Map();

  var moduleIndexData = [];

  for (const moduleGroup of moduleGroups) {
    const moduleGroupPath = path.join("modules", moduleGroup);
    const moduleNames = await getSubdirNames(fs, moduleGroupPath);

    for (const moduleName of moduleNames) {
      const modulePath = `${moduleGroup}/${moduleName}`;
      const versionListUrl = `https://mcr.microsoft.com/v2/bicep/${modulePath}/tags/list`;

      try {
        core.info(`Processing ${modulePath}:...`);
        core.info(`  Retrieving  ${versionListUrl}`);

        const versionListResponse = await axios.get(versionListUrl);
        const tags = versionListResponse.data.tags.sort();

        const properties = {};
        for (const tag of tags) {
          var description = await getModuleDescription(
            github,
            core,
            path,
            modulePath,
            tag,
            context
          );
          if (description) {
            properties[tag] = { description };
            modulesWithDescriptions[modulePath] = true;
          }
        }

        moduleIndexData.push({
          moduleName: modulePath,
          tags,
          properties,
        });
      } catch (error) {
        core.setFailed(error);
      }
    }
  }

  core.info(`Writing moduleIndex.json`);
  await fs.writeFile(
    "moduleIndex.json",
    JSON.stringify(moduleIndexData, null, 2)
  );

  core.info(`Processed ${moduleGroups.length} modules groups.`);
  core.info(`Processed ${moduleIndexData.length} total modules.`);
  core.info(
    `${
      moduleIndexData.filter((m) =>
        Object.keys(m.properties).some((key) =>
          m.properties[key].hasOwnProperty("description")
        )
      ).length
    } modules have a description`
  );
}

module.exports = generateModuleIndexData;
