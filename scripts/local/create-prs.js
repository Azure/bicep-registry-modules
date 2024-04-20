/*

  This script creates a PR for each modules on the local disk that has changes.  It will query interactively for each module.

  Requires that gh be installed (https://cli.github.com/)

    Usage:
    cd repos/bicep-registry-modules
    npm i

    <Do something to make changes in one or modules (e.g. `node scripts/local/regenerate-all.js`)>

    make sure you're logged in to gh
    node scripts/local/create-prs.js

    <You'll have the opportunity to review the PRs before submitting>

*/

const usage = `Usage: see script comments`;

const { runAsync, queryRunAsync } = require("./util/runAsync.js");
const { clearScreen, green, yellow, red, reset } = require("./util/colors");

const { argv } = require("process");

// eslint-disable-next-line prefer-const
let [branchPrefix, commitPrefix] = argv.slice(2);
if (!branchPrefix || !commitPrefix) {
  console.error(usage);
  process.exit(1);
}

branchPrefix = branchPrefix.endsWith("/")
  ? branchPrefix.slice(0, branchPrefix.length - 1)
  : branchPrefix;
console.log(`${green}branch prefix: ${branchPrefix}${reset}`);
console.log(`${green}commit message: ${commitPrefix}${reset}`);

async function getChangedModulesAsync() {
  const changedModules = (await runAsync(`git status modules`))
    .split("\n")
    .filter((line) => line.match(/modified/))
    .map((line) => line.replace(/^.*\smodules\/([^/]+\/[^/]+)\/.*$/g, "$1"))
    // dedupe the list
    .filter((value, index, self) => self.indexOf(value) === index);

  return changedModules;
}

async function CreatePRAsync(modulePath) {
  console.log(
    `${clearScreen}${green}=========== Creating PR for ${modulePath}...${reset}`
  );

  const branchName = `${branchPrefix}/auto/${modulePath}`;
  await runAsync(`git checkout -b ${branchName}`);
  await runAsync(`git add modules/${modulePath}`);
  await runAsync(`git diff --cached`);

  const commitMessage = `${commitPrefix} (${modulePath}) (auto)`;
  const prTitle = `${commitPrefix} (${modulePath}) (auto-generated)`;
  const prBody = `This PR was created by a script. Please review the changes and merge if they look good.`;
  const prSubmitted = await queryRunAsync([
    `git commit -m "${commitMessage}"`,
    `git push -u origin ${branchName}`,
    `gh pr create --title "${prTitle}" --body "${prBody}" --label "Auto-generated"`,
  ]);

  // TODO: Changes get lost for a branch if you say no

  await runAsync(`git checkout main`);
  if (prSubmitted) {
    await runAsync(`git branch -d ${branchName}`);
  } else {
    console.log(
      `${red}Branch ${branchName} contains the unsubmitted changes.${reset}`
    );
  }

  console.log();
}

async function CreatePRs() {
  const changedModules = await getChangedModulesAsync();

  const currentBranch = await runAsync(`git symbolic-ref --short HEAD`, false);
  console.log(`${green}Current branch: ${currentBranch}${reset}`);

  await runAsync(`git checkout main`);

  try {
    for (const modulePath of changedModules) {
      await CreatePRAsync(modulePath);
    }
  } finally {
    await runAsync(`git checkout ${currentBranch}`, false);
    console.log(`${green}Restored branch to ${currentBranch}${reset}`);
  }
}

CreatePRs();
