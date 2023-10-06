// This runs locally the scripts that power the "Publish Module Index" action on github
// (see bicep-registry-modules/.github/workflows/publish-module-index.yml)
// to make it easier to debug locally.
//
// Run via run-generate-module-index{.bat,.sh} from the root of the repo
// after having set up these environment variables:
//
//   GITHUB_PAT: your github PAT
//   GITHUB_OWNER:
//     "bicep" for bicep/bicep-registry-modules
//       sor your github username for a fork of bicep-registry-modules

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
