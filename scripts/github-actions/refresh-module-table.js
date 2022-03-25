function getTimestamp() {
  const now = new Date();
  const year = now.getFullYear();
  const month = (now.getMonth() + 1).toString().padStart(2, "0");
  const date = now.getDate().toString().padStart(2, "0");
  const hours = now.getHours();
  const minutes = now.getMinutes();
  const seconds = now.getSeconds();

  return `${year}${month}${date}${hours}${minutes}${seconds}`;
}

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
 * @param {typeof import("fs")} fs
 * @param {typeof import("path")} path
 */
async function generateModulesTable(fs, path) {
  const tableData = [["Module", "Version", "Docs"]];
  const moduleGroups = getSubdirNames(fs, "modules");

  for (const moduleGroup of moduleGroups) {
    var moduleGroupPath = path.join("modules", moduleGroup);
    var moduleNames = getSubdirNames(fs, moduleGroupPath);

    for (const moduleName of moduleNames) {
      const modulePath = `${moduleGroup}/${moduleName}`;
      const badgeUrl = new URL("https://img.shields.io/badge/dynamic/json");
      const versionListUrl = `https://mcr.microsoft.com/v2/bicep/${modulePath}/tags/list`;

      badgeUrl.searchParams.append("label", "mcr");
      badgeUrl.searchParams.append("query", "$.tags[(@.length-1)]");
      badgeUrl.searchParams.append("url", versionListUrl);

      console.log(badgeUrl.href);

      const module = `\`${modulePath}\``;
      const versionBadge = `<a href="${versionListUrl}"><image src="${badgeUrl.href}"></a>`;

      const moduleRootUrl = `https://github.com/Azure/bicep-registry-modules/tree/main/modules/${modulePath}`;
      const codeLink = `[🦾 Code](${moduleRootUrl}/main.bicep)`;
      const readmeLink = `[📃 Readme](${moduleRootUrl}/README.md)`;
      const docs = `${codeLink} ｜ ${readmeLink}`;

      tableData.push([module, versionBadge, docs]);
    }
  }

  // markdown-table is ESM only, so we cannot use require.
  const { markdownTable } = await import("markdown-table");
  return markdownTable(tableData, { align: ["l", "r", "r"] });
}

/**
 * @param {ReturnType<typeof import("@actions/github").getOctokit>} github
 * @param {typeof import("@actions/github").context} context
 * @param {string} newReadme
 */
async function createPullRequestToUpdateReadme(github, context, newReadme) {
  const branch = `refresh-module-table-${getTimestamp()}`;

  // Create a new branch.
  await github.rest.git.createRef({
    ...context.repo,
    ref: `refs/heads/${branch}`,
    sha: context.sha,
  });

  // Update README.md.
  const { data: treeData } = await github.rest.git.createTree({
    ...context.repo,
    tree: [
      {
        type: "blob",
        mode: "100644",
        path: "README.md",
        content: newReadme,
      },
    ],
    base_tree: context.sha,
  });

  // Create a commit.
  const { data: commitData } = await github.rest.git.createCommit({
    ...context.repo,
    message: "Refresh module table",
    tree: treeData.sha,
    parents: [context.sha],
  });

  // Update HEAD of the new branch.
  await github.rest.git.updateRef({
    ...context.repo,
    // The ref parameter for updateRef is not the same as createRef.
    ref: `heads/${branch}`,
    sha: commitData.sha,
  });

  // Create a pull request.
  const { data: prData } = await github.rest.pulls.create({
    ...context.repo,
    title: "🤖 Refresh module table",
    head: branch,
    base: "main",
    maintainer_can_modify: true,
  });

  return prData.html_url;
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

  const oldReadme = fs.readFileSync("README.md", { encoding: "utf-8" });
  const oldTableMatch = oldReadme.match(
    /(?<=<!-- Begin Module Table -->).*(?=<!-- End Module Table -->)/s
  );

  if (oldTableMatch === null) {
    core.setFailed("Could not find module table markers in the README file.");
  }

  const oldTable = oldTableMatch[0].replace(/^\s+|\s+$/g, "");
  const newTable = await generateModulesTable(fs, path);

  if (oldTable === newTable) {
    core.info("The module table is update-to-date.");
    return;
  }

  if (oldTable !== newTable) {
    const newReadme = oldReadme.replace(oldTable, newTable);
    const newReadmeFormatted = prettier.format(newReadme, {
      parser: "markdown",
    });

    const prUrl = await createPullRequestToUpdateReadme(
      github,
      context,
      newReadmeFormatted
    );
    core.info(
      `The module table is outdated. A pull request ${prUrl} was created to update it.`
    );
  }
}

module.exports = refreshModuleTable;
