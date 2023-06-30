/**
 * @param {object[]} items
 * @param {(item: any) => string} keyGetter
 * @returns
 */
function groupBy(items, keyGetter) {
  const map = new Map();

  for (const item of items) {
    const key = keyGetter(item);
    const collection = map.get(key);
    if (!collection) {
      map.set(key, [item]);
    } else {
      collection.push(item);
    }
  }

  return map;
}

/**
 * @param {ReturnType<typeof import("@actions/github").getOctokit>} github
 * @param {typeof import("@actions/github").context} context
 * @param {string} tag
 */
async function getPublishDate(github, context, tag) {
  const { owner, repo } = context.repo;

  const reference = await github.rest.git.getRef({
    owner,
    repo,
    ref: `tags/${tag}`,
  });
  if (!reference) {
    throw `Could not find tag ${tag}`;
  }

  const commit = await github.rest.git.getCommit({
    owner: context.repo.owner,
    repo: context.repo.repo,
    commit_sha: reference.data.object.sha,
  });
  if (!commit) {
    throw `Could not find commit for tag ${tag}`;
  }

  return commit.data.committer.date.split("T")[0];
}

/**
 * @param {ReturnType<typeof import("@actions/github").getOctokit>} github
 * @param {typeof import("@actions/github").context} context
 * @param {Array<{ moduleName: string, tags: string[] }>} modules
 * @param {typeof import("prettier")} prettier
 * @returns
 */
async function generateModuleGroupTable(github, context, modules, prettier) {
  const moduleGroupTableData = [
    [
      "Module",
      "Latest version",
      "Published on",
      "Source code",
      "Readme",
      "Description",
    ],
  ];

  for (const module of modules) {
    const modulePath = `\`${module.moduleName}\``;

    // module.tags is an sorted array.
    const latestVersion = module.tags.slice(-1)[0];
    const versionListUrl = `https://mcr.microsoft.com/v2/bicep/${module.moduleName}/tags/list`;
    const versionBadgeUrl = `https://img.shields.io/badge/mcr-${latestVersion}-blue`;
    const versionBadge = `<a href="${versionListUrl}"><image src="${versionBadgeUrl}"/></a>`;

    const tag = `${module.moduleName}/${latestVersion}`;
    const publishDate = await getPublishDate(github, context, tag);

    const description =
      module.properties &&
      module.properties[latestVersion]?.description?.replace(/\n|\r/g, " ");

    const moduleRootUrl = `https://github.com/Azure/bicep-registry-modules/tree/main/modules/${module.moduleName}`;
    const sourceCodeButton = `[🦾 Source code](${moduleRootUrl}/main.bicep){: .btn}`;
    const readmeButton = `[📃 Readme](${moduleRootUrl}/README.md){: .btn .btn-purple}`;

    moduleGroupTableData.push([
      modulePath,
      versionBadge,
      publishDate,
      sourceCodeButton,
      readmeButton,
      description,
    ]);
  }

  const { markdownTable } = await import("markdown-table");
  const table = markdownTable(moduleGroupTableData, {
    align: ["l", "r", "r", "r", "r", "l"],
  });

  return prettier.format(table, { parser: "markdown" });
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
async function generateModuleIndexMarkdown({ require, github, context, core }) {
  const fs = require("fs").promises;
  const prettier = require("prettier");

  var moduleIndexMarkdown = `---
layout: default
title: Module Index
nav_order: 1
permalink: /
---

# Module Index
{: .fs-9}

---

`;

  const moduleIndexDataContent = await fs.readFile("moduleIndex.json", {
    encoding: "utf-8",
  });
  if (!moduleIndexDataContent) {
    throw "Could not read moduleIndex.json";
  }

  const moduleIndexData = JSON.parse(moduleIndexDataContent);
  const moduleGroups = groupBy(
    moduleIndexData,
    (x) => x.moduleName.split("/")[0]
  );

  for (const [moduleGroup, modules] of moduleGroups) {
    core.debug(`Generating ${moduleGroup}...`);

    const moduleGroupTable = await generateModuleGroupTable(
      github,
      context,
      modules,
      prettier
    );

    moduleIndexMarkdown += `## ${moduleGroup}\n\n`;
    moduleIndexMarkdown += moduleGroupTable;
    moduleIndexMarkdown += "\n\n";
  }

  await fs.writeFile("docs/jekyll/index.md", moduleIndexMarkdown);
}

module.exports = generateModuleIndexMarkdown;
