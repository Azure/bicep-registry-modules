/**
 * @typedef Params
 * @property {typeof require} require
 * @property {ReturnType<typeof import("@actions/github").getOctokit>} github
 * @property {typeof import("@actions/github").context} context
 * @property {typeof import("@actions/core")} core
 * @property {string} moduleDir
 * @property {string} baseVersion
 * @property {string} headVersion
 *
 * @param {Params} params
 */
async function createTag({
  require,
  github,
  context,
  core,
  moduleDir,
  baseVersion,
  headVersion,
}) {
  const semverCompare = require("semver/functions/compare");
  const base = context.payload.before;
  const head = context.payload.after;
  const compareResult = semverCompare(headVersion, baseVersion);

  if (compareResult < 0) {
    core.setFailed(
      `The version ${headVersion} calculated at the commit ${head} (head) is smaller than the version ${baseVersion} calculated at the base commit ${base} (base).`
    );
  }

  if (compareResult === 0) {
    core.info(`No version update detected.`);
    return "";
  }

  const red = "\u001b[31m";
  const green = "\u001b[32m";
  const reset = "\u001b[0m";
  core.info(
    `Detected version update: ${red}${baseVersion} (old) ${reset}-> ${green}${headVersion} (new).`
  );

  const modulePath = moduleDir.substring(moduleDir.indexOf("/") + 1);
  const tag = `${modulePath}/${headVersion}`;

  await github.rest.git.createRef({
    owner: context.repo.owner,
    repo: context.repo.repo,
    ref: `refs/tags/${tag}`,
    sha: context.sha,
  });

  core.info(`Created a new tag: ${tag} (${head}).`);
  return tag;
}

module.exports = createTag;
