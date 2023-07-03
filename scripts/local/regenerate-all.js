/*

  This script is used to regenerate all the modules in the current repo. Also updates the examples
  in the README.md to the *next* version of the module (making it ready for checkin).

  Usage:
    cd repos/bicep-registry-modules
    node scripts/local/regenerate-all.js

*/

const { resolve } = require("path");
const { updateReadmeExamples } = require("./util/updateReadmeExamples.js");
const { runAsync } = require("./util/runAsync.js");
const { existsSync } = require("fs");
const {
  getLatestModuleVersionsAsync,
} = require("./util/getLatestModuleVersionsAsync.js");
const { green, reset, yellow } = require("./util/colors");
const semver = require("semver");

let brm = `..\\bicep\\src\\Bicep.RegistryModuleTool\\Bin\\Debug\\net7.0\\Azure.Bicep.RegistryModuleTool`;
brm = existsSync(brm) ? brm : brm + ".exe";
brm = existsSync(brm) ? brm : "brm";
brm = resolve(brm);

console.warn(`Using this brm: ${brm}`);

function getNextVersion(version) {
  return semver.inc(version, "patch");
}

async function regenerateAllAsync() {
  const modules = await getLatestModuleVersionsAsync();

  for (const [modulePath, version] of modules) {
    var currentDir = process.cwd();
    process.chdir(resolve(`modules/${modulePath}`));

    try {
      let needsGenerate = false;

      try {
        console.warn(`${yellow}Validating: ${modulePath}${reset}`);
        await runAsync(`${brm} validate`);
      } catch (err) {
        if (
          /Please run "brm generate"/.test(String(err)) ||
          /The "summary" property in metadata.json does not match/.test(
            String(err)
          )
        ) {
          needsGenerate = true;
        } else {
          throw err;
        }
      }

      if (needsGenerate) {
        console.error(
          `${yellow}Generating: ${modulePath} (version ${version})${reset}`
        );
        await runAsync(`${brm} generate`);

        console.error(
          `${yellow}Updating README for ${modulePath} (version ${version})${reset}`
        );
        process.chdir(resolve(currentDir));
        await updateReadmeExamples(
          modulePath,
          version,
          getNextVersion(version)
        );
      } else {
        console.error(
          `${green}Does not need regeneration: ${modulePath}${reset}`
        );
      }
    } finally {
      process.chdir(resolve(currentDir));
    }
  }
}

regenerateAllAsync();
