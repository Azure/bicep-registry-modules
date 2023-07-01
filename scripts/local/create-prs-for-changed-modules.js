/*

  This script creates a PR for module on the local disk that has changes

*/

const usage = `Usage:
cd repos/bicep-registry-modules
export GITHUB_PAT=...
export GITHUB_OWNER=...   (e.g. "azure" for "azure/bicep-registry-modules")
node scripts/local/create-prs-for-changed-modules.js <branch-prefix> <title>

e.g.
node scripts/local/create-prs-for-changed-modules.js myname "feat: My PR Title"
`;

const { exec } = require("child_process");
const { promisify } = require("util");
const execPromise = promisify(exec);

const red = "\u001b[31m";
const green = "\u001b[32m";
const blue = "\u001b[34m";
const yellow = "\u001b[33m";
const reset = "\u001b[0m";

const { argv } = require("process");

const [branchPrefix, title] = argv.slice(2);
console.log(`${green}branchPrefix: ${branchPrefix}${reset}`);
console.log(`${green}title: ${title}${reset}`);

if (!branchPrefix || !title) {
  console.error(usage);
  process.exit(1);
}

let runAll = false;

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

async function runAsync(cmd, echo = true) {
  if (echo) {
    console.log(cmd);
  }

  const response = await execPromise(cmd);
  if (echo) {
    console.warn(`> ${response.stdout}`);
  }
  return response.stdout;
}

async function queryRunAsync(cmd) {
  const answer =
    runAll === true ||
    (await queryUserAsync(`Run "${yellow}${cmd}${reset}"? (y/n/a) `));

  console.log(`answer: ${answer}`);

  if (answer === "y") {
    return await runAsync(cmd);
  } else if (answer === "a") {
    runAll = true;
    return await runAsync(cmd, false);
  }
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

async function CreatePRAsync(modulePath) {
  console.log(`Creating PR for ${modulePath}...`);

  const branchName = `${branchPrefix}/${modulePath}`;
  await runAsync(`git checkout -b ${branchName}`);
  await runAsync(`git add modules/${modulePath}`);
  await runAsync(`git status`);

  await queryRunAsync(`git status`);

  await runAsync(`git checkout main`);
  await runAsync(`git branch -d ${branchName}`);
  console.log();
}

async function CreatePRs() {
  const changedModules = await getChangedModulesAsync();

  const currentBranch = await runAsync(`git symbolic-ref --short HEAD`, false);
  console.log(`${green}Current branch: ${currentBranch}${reset}`);

  try {
    await runAsync(`git checkout main`);

    for (const modulePath of changedModules) {
      await CreatePRAsync(modulePath);
      break;
    }
  } finally {
    await runAsync(`git checkout ${currentBranch}`);
    console.log(`${green}Current branch: ${currentBranch}${reset}`);
  }
}

CreatePRs();
