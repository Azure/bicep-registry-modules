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

async function getModuleNamesWithTags({ require, github, context, core }) {
  const fs = require("fs");
  const path = require("path");
  const axios = require("axios").default;

  const moduleGroups = getSubdirNames(fs, "modules");
  var result = {};

  for (const moduleGroup of moduleGroups) {
    var moduleGroupPath = path.join("modules", moduleGroup);
    var moduleNames = getSubdirNames(fs, moduleGroupPath);

    for (const moduleName of moduleNames) {
      const modulePath = `${moduleGroup}/${moduleName}`;
      const versionListUrl = `https://mcr.microsoft.com/v2/bicep/${modulePath}/tags/list`;

      try {
        const versionListResponse = await axios.get(versionListUrl);
        const tags = versionListResponse.data.tags.sort();

        result[modulePath] = tags;
      } catch (error) {
        core.setFailed(error);
      }
    }
  }

  const oldModuleNamesWithTags = fs.readFileSync("moduleNamesWithTags.json", {
    encoding: "utf-8",
  });
  const newModuleNamesWithTags = JSON.stringify(result);

  if (oldModuleNamesWithTags === newModuleNamesWithTags) {
    core.info("The module names with tags information is up to date.");
    return;
  }

  const prUrl = await createPullRequestToUpdateBicepModuleRegistryReferences(
    github,
    context,
    newModuleNamesWithTags
  );
  core.info(
    `The module table is outdated. A pull request ${prUrl} was created to update it.`
  );
}

/**
 * @param {ReturnType<typeof import("@actions/github").getOctokit>} github
 * @param {typeof import("@actions/github").context} context
 * @param {string} newBicepRegistryModuleReferences
 */
async function createPullRequestToUpdateBicepModuleRegistryReferences(github, context, newBicepRegistryModuleReferences) {
  const branch = `refresh-bicep-registry-module-references-${getTimestamp()}`;

  // Create a new branch.
  await github.rest.git.createRef({
    ...context.repo,
    ref: `refs/heads/${branch}`,
    sha: context.sha,
  });

  // Update moduleNamesWithTags.json
  const { data: treeData } = await github.rest.git.createTree({
    ...context.repo,
    tree: [
      {
        type: "blob",
        mode: "100644",
        path: "moduleNamesWithTags.json",
        content: newBicepRegistryModuleReferences,
      },
    ],
    base_tree: context.sha,
  });

  // Create a commit.
  const { data: commitData } = await github.rest.git.createCommit({
    ...context.repo,
    message: "Refresh bicep registry module references",
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
    title: "Refresh bicep registry module references",
    head: branch,
    base: "dev/bhsubra/CollectModuleNamesAndTags",
    maintainer_can_modify: true,
  });

  return prData.html_url;
}

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

module.exports = getModuleNamesWithTags;
