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
  mainJsonPath,
  gitTag,
  context
) {
  const gitTagRef = `tags/${gitTag}`;

  core.info(`  Retrieving main.json at Git tag ref ${gitTagRef}`);

  const response = await github.rest.repos.getContent({
    owner: context.repo.owner,
    repo: context.repo.repo,
    path: mainJsonPath,
    ref: gitTagRef,
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
  const axios = require("axios").default;
  const moduleIndexData = [];

  let numberOfModuleGroupsProcessed = 0;

  // BRM Modules
  for (const moduleGroup of await getSubdirNames(fs, "modules")) {
    const moduleGroupPath = `modules/${moduleGroup}`;
    const moduleNames = await getSubdirNames(fs, moduleGroupPath);

    for (const moduleName of moduleNames) {
      const modulePath = `${moduleGroupPath}/${moduleName}`;
      const mainJsonPath = `${modulePath}/main.json`;
      // BRM module git tags do not include the modules/ prefix.
      const mcrModulePath = modulePath.slice(8);
      const tagListUrl = `https://mcr.microsoft.com/v2/bicep/${mcrModulePath}/tags/list`;

      try {
        core.info(`Processing BRM Module "${modulePath}"...`);
        core.info(`  Getting available tags at "${tagListUrl}"...`);

        const tagListResponse = await axios.get(tagListUrl);
        const tags = tagListResponse.data.tags.sort();

        const properties = {};
        for (const tag of tags) {
          // Using mcrModulePath because BRM module git tags do not include the modules/ prefix
          const gitTag = `${mcrModulePath}/${tag}`;
          const documentationUri = `https://github.com/Azure/bicep-registry-modules/tree/${gitTag}/${modulePath}/README.md`;
          const description = await getModuleDescription(
            github,
            core,
            mainJsonPath,
            gitTag,
            context
          );

          properties[tag] = { description, documentationUri };
        }

        moduleIndexData.push({
          moduleName: mcrModulePath,
          tags,
          properties,
        });
      } catch (error) {
        core.setFailed(error);
      }
    }

    numberOfModuleGroupsProcessed++;
  }

  for (const avmModuleRoot of ["avm/res", "avm"]) {
    // Resource module path pattern: `avm/res/${moduleGroup}/${moduleName}`
    // Pattern module path pattern: `avm/ptn/${moduleName}` (no nested module group)
    const avmModuleGroups =
      avmModuleRoot === "avm/res"
        ? await getSubdirNames(fs, avmModuleRoot)
        : ["ptn"];

    for (const moduleGroup of avmModuleGroups) {
      const moduleGroupPath = `${avmModuleRoot}/${moduleGroup}`;
      const moduleNames = await getSubdirNames(fs, moduleGroupPath);

      for (const moduleName of moduleNames) {
        const modulePath = `${moduleGroupPath}/${moduleName}`;
        const mainJsonPath = `${modulePath}/main.json`;
        const mcrModulePath = modulePath
          .replace(/-/g, "")
          .replace(/[/\\]/g, "-");
        const tagListUrl = `https://mcr.microsoft.com/v2/bicep/${mcrModulePath}/tags/list`;

        try {
          core.info(`Processing AVM Module "${modulePath}"...`);
          core.info(`  Getting available tags at "${tagListUrl}"...`);

          const tagListResponse = await axios.get(tagListUrl);
          const tags = tagListResponse.data.tags.sort();

          const properties = {};
          for (const tag of tags) {
            const gitTag = `${modulePath}/${tag}`;
            const documentationUri = `https://github.com/Azure/bicep-registry-modules/tree/${gitTag}/${modulePath}/README.md`;
            const description = await getModuleDescription(
              github,
              core,
              mainJsonPath,
              gitTag,
              context
            );

            properties[tag] = { description, documentationUri };
          }

          moduleIndexData.push({
            moduleName: mcrModulePath,
            tags,
            properties,
          });
        } catch (error) {
          core.setFailed(error);
        }
      }

      numberOfModuleGroupsProcessed++;
    }
  }

  core.info(`Writing moduleIndex.json`);
  await fs.writeFile(
    "moduleIndex.json",
    JSON.stringify(moduleIndexData, null, 2)
  );

  core.info(`Processed ${numberOfModuleGroupsProcessed} modules groups.`);
  core.info(`Processed ${moduleIndexData.length} total modules.`);
  core.info(
    `${
      moduleIndexData.filter((m) =>
        Object.keys(m.properties).some(
          (key) => "description" in m.properties[key]
        )
      ).length
    } modules have a description`
  );
}

module.exports = generateModuleIndexData;
