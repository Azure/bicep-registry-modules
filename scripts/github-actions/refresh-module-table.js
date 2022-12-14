import { CreatePullRequestHelper } from "./create-pull-request-helper.js";

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

/**
 * @param {typeof import("axios").default} axios
 * @param {typeof import("fs")} fs
 * @param {typeof import("path")} path
 * @param {typeof import("@actions/core")} core
 */
async function generateModulesTable(axios, fs, path, core) {
  const tableData = [["Module", "Version", "Docs"]];
  const moduleGroups = getSubdirNames(fs, "modules");

  for (const moduleGroup of moduleGroups) {
    var moduleGroupPath = path.join("modules", moduleGroup);
    var moduleNames = getSubdirNames(fs, moduleGroupPath);

    for (const moduleName of moduleNames) {
      const modulePath = `${moduleGroup}/${moduleName}`;
      const versionListUrl = `https://mcr.microsoft.com/v2/bicep/${modulePath}/tags/list`;

      try {
        const versionListResponse = await axios.get(versionListUrl);
        const latestVersion = versionListResponse.data.tags.sort().at(-1);
        const badgeUrl = `https://img.shields.io/badge/mcr-${latestVersion}-blue`;

        core.debug(badgeUrl.href);

        const module = `\`${modulePath}\``;
        const versionBadge = `<a href="${versionListUrl}"><image src="${badgeUrl}"></a>`;

        const moduleRootUrl = `https://github.com/Azure/bicep-registry-modules/tree/main/modules/${modulePath}`;
        const codeLink = `[🦾 Code](${moduleRootUrl}/main.bicep)`;
        const readmeLink = `[📃 Readme](${moduleRootUrl}/README.md)`;
        const docs = `${codeLink} ｜ ${readmeLink}`;

        tableData.push([module, versionBadge, docs]);
      } catch (error) {
        core.setFailed(error);
      }
    }
  }

  // markdown-table is ESM only, so we cannot use require.
  const { markdownTable } = await import("markdown-table");
  return markdownTable(tableData, { align: ["l", "r", "r"] });
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
async function refreshModuleTable({ require, github, context, core }) {
  const fs = require("fs");
  const path = require("path");
  const prettier = require("prettier");
  const axios = require("axios").default;

  const oldReadme = fs.readFileSync("README.md", { encoding: "utf-8" });
  const oldTableMatch = oldReadme.match(
    /(?<=<!-- Begin Module Table -->).*(?=<!-- End Module Table -->)/s
  );

  if (oldTableMatch === null) {
    core.setFailed("Could not find module table markers in the README file.");
  }

  const oldTable = oldTableMatch[0].replace(/^\s+|\s+$/g, "");
  const newTable = await generateModulesTable(axios, fs, path, core);
  const newReadme = oldReadme.replace(oldTable, newTable);
  const newReadmeFormatted = prettier.format(newReadme, {
    parser: "markdown",
  });

  if (oldReadme === newReadmeFormatted) {
    core.info("The module table is update-to-date.");
    return;
  }

  const createPullRequestHelper = await new CreatePullRequestHelper(
    "dev/bhsubra/CreateBicepRegistryModuleReferences",
    "refresh-module-metadata",
    newReadmeFormatted,
    context,
    github,
    "Refresh module table",
    "README.md",
    "🤖 Refresh module table"
  );
  const prUrl = createPullRequestHelper.createPullRequest();

  core.info(
    `The module table is outdated. A pull request ${prUrl} was created to update it.`
  );
}

module.exports = refreshModuleTable;
