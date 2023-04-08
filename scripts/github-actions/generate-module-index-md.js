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
 * @param {string} commitSha
 */
async function getCommitDate(github, context, commitSha) {
  const commit = await github.rest.git.getCommit({
    owner: context.repo.owner,
    repo: context.repo.repo,
    commit_sha: commitSha,
  });

  return commit.data.committer.date.split("T")[0];
}

/**
 *
 * @param {Array<{ moduleName: string, tags: string[] }>} modules
 * @param {Map<string, string>} commitIdsByTag
 * @param {typeof import("prettier")} prettier
 * @returns
 */
async function generateModuleGroupTable(modules, publishDateByTag, prettier) {
  const moduleGroupTableData = [
    ["Module", "Published on", "Source code", "Readme"],
  ];

  for (const module of modules) {
    const versions = module.tags.reverse();

    for (const version of versions) {
      const modulePath = `\`${module.moduleName}:${version}\``;

      const tag = `${module.moduleName}/${version}`;
      const publishDate = publishDateByTag.get(tag);

      const moduleRootUrl = `https://github.com/Azure/bicep-registry-modules/blob/${module.moduleName}/${version}/modules/${module.moduleName}`;
      const sourceCodeButton = `[🦾 Source code](${moduleRootUrl}/main.bicep){: .btn}`;
      const readmeButton = `[📃 Readme](${moduleRootUrl}/README.md){: .btn .btn-purple}`;

      moduleGroupTableData.push([
        modulePath,
        publishDate,
        sourceCodeButton,
        readmeButton,
      ]);
    }
  }

  const { markdownTable } = await import("markdown-table");
  const table = markdownTable(moduleGroupTableData, {
    align: ["l", "r", "r", "r"],
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

  const { owner, repo } = context.repo;
  const tags = await github.paginate(
    github.rest.repos.listTags,
    { owner, repo },
    (response) => response.data
  );

  const publishDateByTag = new Map(
    await Promise.all(
      tags.map(async ({ name, commit }) => {
        const date = await getCommitDate(github, context, commit.sha);
        return [name, date];
      })
    )
  );

  const moduleIndexDataContent = await fs.readFile("moduleIndex.json", {
    encoding: "utf-8",
  });
  const moduleIndexData = JSON.parse(moduleIndexDataContent);
  const moduleGroups = groupBy(
    moduleIndexData,
    (x) => x.moduleName.split("/")[0]
  );

  for (const [moduleGroup, modules] of moduleGroups) {
    core.debug(`Generating ${moduleGroup}...`);

    const moduleGroupTable = await generateModuleGroupTable(
      modules,
      publishDateByTag,
      prettier
    );

    moduleIndexMarkdown += `## ${moduleGroup}\n\n`;
    moduleIndexMarkdown += moduleGroupTable;
    moduleIndexMarkdown += "\n\n";
  }

  await fs.writeFile("docs/jekyll/index.md", moduleIndexMarkdown);
}

module.exports = generateModuleIndexMarkdown;
