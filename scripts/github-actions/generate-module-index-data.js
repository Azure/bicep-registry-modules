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
  moduleType = "brm",
  tag,
  context
) {
  // Retrieve the main.json file as it existed for the given tag
  const ref = `tags/${modulePath}/${tag}`;
  core.info(`  Retrieving main.json at ref ${ref}`);

  let mainJsonPath;
  if (moduleType === "brm") {
    mainJsonPath = path
      .join("modules", modulePath, "main.json")
      .replace(/\\/g, "/");
  } else if (moduleType === "avm-res") {
    mainJsonPath = path
      .join("avm/res", modulePath, "main.json")
      .replace(/\\/g, "/");
  } else if (moduleType === "avm-ptn") {
    mainJsonPath = path
      .join("avm/ptn", modulePath, "main.json")
      .replace(/\\/g, "/");
  } else {
    throw new Error(
      `Invalid module type provided to getModuleDescription function, permitted type are brm, avm-res, avm-ptn. The module type provided was: ${moduleType}`
    );
  }

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
  const moduleGroupsAvmRes = await getSubdirNames(fs, "avm/res");
  const moduleGroupsAvmPtn = await getSubdirNames(fs, "avm/ptn");
  const modulesWithDescriptions = new Map();

  var allModuleGroups = [];
  allModuleGroups.push(...moduleGroups);
  allModuleGroups.push(...moduleGroupsAvmRes);
  allModuleGroups.push(...moduleGroupsAvmPtn);

  var moduleIndexData = [];

  // BRM Modules
  for (const moduleGroup of moduleGroups) {
    const moduleGroupPath = path.join("modules", moduleGroup);
    const moduleNames = await getSubdirNames(fs, moduleGroupPath);

    for (const moduleName of moduleNames) {
      const modulePath = `${moduleGroup}/${moduleName}`;
      const versionListUrl = `https://mcr.microsoft.com/v2/bicep/${modulePath}/tags/list`;

      try {
        core.info(`Processing BRM Module ${modulePath}:...`);
        core.info(`  Retrieving BRM Module ${versionListUrl}`);

        const versionListResponse = await axios.get(versionListUrl);
        const tags = versionListResponse.data.tags.sort();

        const properties = {};
        for (const tag of tags) {
          var description = await getModuleDescription(
            github,
            core,
            path,
            modulePath,
            (moduleType = "brm"),
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

  // AVM Resource Modules
  for (const moduleGroup of moduleGroupsAvmRes) {
    const moduleGroupPath = path.join("avm/res", moduleGroup);
    const moduleNames = await getSubdirNames(fs, moduleGroupPath);

    for (const moduleName of moduleNames) {
      const modulePath = `avm/res/${moduleGroup}/${moduleName}`;
      const versionListUrl = `https://mcr.microsoft.com/v2/bicep/${modulePath}/tags/list`;
      const moduleBicepRegistryRefSplit = modulePath
        .split(/[\/\\]avm[\/\\]/)
        .pop();
      const moduleBicepRegistryRefReplace = moduleBicepRegistryRefSplit
        .replace(/-/g, "")
        .replace(/[\/\\]/g, "-");
      const moduleBicepRegistryRef = moduleBicepRegistryRefReplace;

      try {
        core.info(`Processing AVM Resource Module ${modulePath}:...`);
        core.info(`  Retrieving AVM Resource Module ${versionListUrl}`);
        core.info(`    Git Tag: ${modulePath}`);
        core.info(`    BRM Ref: ${moduleBicepRegistryRef}`);

        const versionListResponse = await axios.get(versionListUrl);
        const tags = versionListResponse.data.tags.sort();

        const properties = {};
        for (const tag of tags) {
          var description = await getModuleDescription(
            github,
            core,
            path,
            modulePath,
            (moduleType = "avm-res"),
            tag,
            context
          );
          if (description) {
            properties[tag] = { description };
            modulesWithDescriptions[modulePath] = true;
          }
        }

        moduleIndexData.push({
          moduleName: moduleBicepRegistryRef,
          tags,
          properties,
        });
      } catch (error) {
        core.setFailed(error);
      }
    }
  }

  // AVM Pattern Modules
  for (const moduleName of moduleGroupsAvmPtn) {
    const modulePath = `avm/ptn/${moduleName}`;
    const versionListUrl = `https://mcr.microsoft.com/v2/bicep/${modulePath}/tags/list`;
    const moduleBicepRegistryRefSplit = modulePath
      .split(/[\/\\]avm[\/\\]/)
      .pop();
    const moduleBicepRegistryRefReplace = moduleBicepRegistryRefSplit
      .replace(/-/g, "")
      .replace(/[\/\\]/g, "-");
    const moduleBicepRegistryRef = moduleBicepRegistryRefReplace;

    try {
      core.info(`Processing AVM Pattern Module ${modulePath}:...`);
      core.info(`  Retrieving AVM Pattern Module ${versionListUrl}`);
      core.info(`    Git Tag: ${modulePath}`);
      core.info(`    BRM Ref: ${moduleBicepRegistryRef}`);

      const versionListResponse = await axios.get(versionListUrl);
      const tags = versionListResponse.data.tags.sort();

      const properties = {};
      for (const tag of tags) {
        var description = await getModuleDescription(
          github,
          core,
          path,
          modulePath,
          (moduleType = "avm-ptn"),
          tag,
          context
        );
        if (description) {
          properties[tag] = { description };
          modulesWithDescriptions[modulePath] = true;
        }
      }

      moduleIndexData.push({
        moduleName: moduleBicepRegistryRef,
        tags,
        properties,
      });
    } catch (error) {
      core.setFailed(error);
    }
  }

  core.info(`Writing moduleIndex.json`);
  await fs.writeFile(
    "moduleIndex.json",
    JSON.stringify(moduleIndexData, null, 2)
  );

  core.info(`Processed ${allModuleGroups.length} modules groups.`);
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
