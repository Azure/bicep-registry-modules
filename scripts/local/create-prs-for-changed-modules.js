/*

  This script creates a PR for module on the local disk that has changes

  Usage:
    cd repos/bicep-registry-modules
    export GITHUB_PAT=...
    export GITHUB_OWNER=...   (e.g. "azure" for "azure/bicep-registry-modules")
    node scripts/local/create-prs-for-changed-modules.js <branch-prefix>

*/

const { exec } = require("child_process");
const { promisify } = require("util");
const execPromise = promisify(exec);
const { argv } = require("process");

const { branchPrefix } = argv.slice(2);

const red = "\u001b[31m";
const green = "\u001b[32m";
const blue = "\u001b[34m";
const yellow = "\u001b[33m";
const reset = "\u001b[0m";

function queryUserAsync(question) {
  const readline = require("readline").createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  return new Promise((resolve) => {
    readline.question(question, (answer) => {
      readline.close();
      resolve(answer);
    });
  });
}

async function run(cmd, echo = true) {
  if (echo) {
    console.log(cmd);
  }

  const response = await execPromise(cmd);
  if (echo) {
    console.warn(`> ${response.stdout}`);
  }
  return response.stdout;
}

async function getChangedModulesAsync() {
  const changedModules = (await execPromise(`git status modules`)).stdout
    .split("\n")
    .filter((line) => line.match(/modified/))
    .map((line) => line.replace(/^.*\smodules\/([^/]+\/[^/]+)\/.*$/g, "$1"))
    // dedupe the list
    .filter((value, index, self) => self.indexOf(value) === index);

  return changedModules;
}

async function CreatePR(modulePath) {
  console.log(`Creating PR for ${modulePath}...`);

  const branchName = `${branchPrefix}/${modulePath}`;
  await run(`git checkout -b ${branchName}`);
  await run(`git add modules/${modulePath}`);
  await run(`git status`);
  await run(`git checkout main`);
  await run(`git branch -d ${branchName}`);
  console.log();
}

async function CreatePRs() {
  const changedModules = await getChangedModulesAsync();

  const currentBranch = await run(`git symbolic-ref --short HEAD`, false);
  console.log(`${green}Current branch: ${currentBranch}${reset}`);

  try {
    await run(`git checkout main`);

    for (const modulePath of changedModules) {
      await CreatePR(modulePath);
      break;
    }
  } finally {
    await run(`git checkout ${currentBranch}`);
    console.log(`${green}Current branch: ${currentBranch}${reset}`);
  }
}

CreatePRs();
