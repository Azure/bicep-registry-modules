// Must run from the repo root

const path = require("path");
const core = require("@actions/core");

const process = require("process");
if (!process.env.GITHUB_PAT) {
  console.error("Need to set GITHUB_PAT");
  return;
}
if (!process.env.GITHUB_OWNER) {
  console.error(
    'Need to set GITHUB_OWNER (e.g. "bicep" for "bicep/bicep-registry-modules"'
  );
  return;
}

const github = require("@actions/github").getOctokit(process.env.GITHUB_PAT);

const context = {
  repo: { owner: process.env.GITHUB_OWNER, repo: "bicep-registry-modules" },
};

const scriptGenerateModuleIndexData = require(path.join(
  process.cwd(),
  "scripts/github-actions/generate-module-index-data.js"
));

scriptGenerateModuleIndexData({ require, github, context, core }).then(() => {
  const scriptGenerateModuleIndexMarkdown = require(path.join(
    process.cwd(),
    "scripts/github-actions/generate-module-index-md.js"
  ));

  scriptGenerateModuleIndexMarkdown({ require, github, context, core }).then(
    () => {
      console.info("Done.");
    }
  );
});
