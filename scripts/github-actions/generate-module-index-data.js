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

  // Get the SHA of the commit
  const {
    data: {
      object: { sha: commitSha },
    },
  } = await github.rest.git.getRef({
    owner: context.repo.owner,
    repo: context.repo.repo,
    ref: gitTagRef,
  });

  // Get the tree data
  const {
    data: { tree },
  } = await github.rest.git.getTree({
    owner: context.repo.owner,
    repo: context.repo.repo,
    tree_sha: commitSha,
    recursive: true,
  });

  // Find the file in the tree
  const file = tree.find((f) => f.path === mainJsonPath);
  if (!file) {
    throw new Error(`File ${mainJsonPath} not found in repository`);
  }

  // Get the blob data
  const {
    data: { content },
  } = await github.rest.git.getBlob({
    owner: context.repo.owner,
    repo: context.repo.repo,
    file_sha: file.sha,
  });

  // content is base64 encoded, so decode it
  const fileContent = Buffer.from(content, "base64").toString("utf8");

  // Parse the main.json file
  if (fileContent !== "") {
    const json = JSON.parse(fileContent);
    return json.metadata.description;
  } else {
    throw new Error(
      "The specified path does not represent a file or it is empty."
    );
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
  const { existsSync } = require("fs");
  const axios = require("axios").default;
  const moduleIndexData = [];

  let numberOfModuleGroupsProcessed = 0;

  // BRM Modules
  for (const moduleGroup of await getSubdirNames(fs, "modules")) {
    const moduleGroupPath = `modules/${moduleGroup}`;
    const moduleNames = await getSubdirNames(fs, moduleGroupPath);

    for (const moduleName of moduleNames) {
      const modulePath = `${moduleGroupPath}/${moduleName}`;
      const archivedFilePath = `${modulePath}/ARCHIVED.md`;

      if (existsSync(archivedFilePath)) {
        continue;
      }

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

  for (const avmModuleRoot of ["avm/res", "avm/ptn"]) {
    // Resource module path pattern: `avm/res/${moduleGroup}/${moduleName}`
    // Pattern module path pattern: `avm/ptn/${moduleGroup}/${moduleName}`
    const avmModuleGroups = await getSubdirNames(fs, avmModuleRoot);

    for (const moduleGroup of avmModuleGroups) {
      const moduleGroupPath = `${avmModuleRoot}/${moduleGroup}`;
      const moduleNames = await getSubdirNames(fs, moduleGroupPath);

      for (const moduleName of moduleNames) {
        const modulePath = `${moduleGroupPath}/${moduleName}`;
        const mainJsonPath = `${modulePath}/main.json`;
        const tagListUrl = `https://mcr.microsoft.com/v2/bicep/${modulePath}/tags/list`;

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
            moduleName: modulePath,
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
