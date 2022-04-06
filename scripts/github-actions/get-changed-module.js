/**
 * @typedef Params
 * @property {typeof require} require
 * @property {ReturnType<typeof import("@actions/github").getOctokit>} github
 * @property {typeof import("@actions/github").context} context
 * @property {typeof import("@actions/core")} core
 *
 * @param {Params} params
 */
async function getChangedModule({ require, github, context, core }) {
  let base;
  let head;

  switch (context.eventName) {
    case "pull_request":
      base = context.payload.pull_request.base.sha;
      head = context.payload.pull_request.head.sha;
      break;
    case "push":
      base = context.payload.before;
      head = context.payload.after;
      break;
    default:
      core.setFailed(`Not supported event: ${context.eventName}.`);
  }

  const { status, data } = await github.rest.repos.compareCommitsWithBasehead({
    owner: context.repo.owner,
    repo: context.repo.repo,
    basehead: `${base}...${head}`,
  });

  if (status !== 200) {
    core.setFailed(
      `Expected github.rest.repos.compareCommitsWithBasehead to return 200, got ${status}.`
    );
  }

  if (context.eventName === "push" && data.status !== "ahead") {
    core.setFailed(
      `The head commit ${head} is not ahead of the base commit ${base}.`
    );
  }

  const path = require("path");
  const fs = require("fs");
  const cyan = "\u001b[36;1m";

  const moduleDirs = [
    ...new Set(
      data.files
        .filter((file) => file.filename.startsWith("modules/"))
        .map((file) => {
          const dir = path.dirname(file.filename);
          const segments = dir.split("/");
          // modules/moduleFolder/moduleRoot/* => modules/moduleFolder/moduleRoot
          return segments.slice(0, 3).join("/");
        })
        // Ignore removed module directories.
        .filter((dir) => fs.existsSync(dir))
    ),
  ];

  switch (moduleDirs.length) {
    case 0:
      core.info("No changed module found.");
      return "";
    case 1:
      core.info("Found 1 changed module:");
      core.info(`- ${cyan}${moduleDirs[0]}`);
      return moduleDirs[0];
    default:
      core.info(`Found ${moduleDirs.length} changed modules:`);
      moduleDirs.forEach((dir) => core.info(`- ${cyan}${dir}`));
      core.setFailed("Only one module can be added or updated at a time.");
  }
}

module.exports = getChangedModule;
