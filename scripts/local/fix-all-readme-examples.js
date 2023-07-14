/*

  This script updates the examples in all README.md files to the *current* version.

    Usage:
    cd repos/bicep-registry-modules
    node scripts/local/fix-all-readme-examples.js

*/

const { updateReadmeExamples } = require("./util/updateReadmeExamples.js");
const {
  getLatestModuleVersionsAsync,
} = require("./util/getLatestModuleVersionsAsync");

async function regenerateAllAsync() {
  const modules = await getLatestModuleVersionsAsync();

  for (const [modulePath, version] of modules) {
    updateReadmeExamples(modulePath, version, version);
  }
}

regenerateAllAsync();
