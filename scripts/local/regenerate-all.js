const { exec } = require("child_process");
const { promisify } = require("util");
const execPromise = promisify(exec);

const { updateReadmeExamplesAsync } = require("./update-readme-examples.js");

function parseTag(tag) {
  const parseTagScript = require("../github-actions/parse-tag.js");

  let modulePath, version;
  parseTagScript({
    core: {
      setOutput: (key, value) => {
        if (key === "version") {
          version = value;
        } else if (key === "module_path") {
          modulePath = value;
        }
      },
      setFailed: (message) => {
        throw new Error(message);
      },
    },
    tag,
  });

  return { modulePath, version };
}

async function getLatestModulesAsync() {
  const tags = (await execPromise(`git tag -l`)).stdout
    .split("\n")
    .filter((tag) => tag !== "");
  const latestModules = new Map();
  for (const tag of tags) {
    const { modulePath, version } = parseTag(tag);
    if (!latestModules.has(modulePath)) {
      latestModules.set(modulePath, version);
    } else {
      const currentVersion = latestModules.get(modulePath);
      if (version > currentVersion) {
        latestModules.set(modulePath, version);
      }
    }
  }

  return Array.from(latestModules);
}

async function regenerateAllAsync() {
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

  const modules = await getLatestModulesAsync();

  for (const [modulePath, version] of modules) {
    await updateReadmeExamplesAsync(modulePath, version);
  }

  //await updateReadmeVersion(modulePath, version);
  // const github = require("@actions/github").getOctokit(process.env.GITHUB_PAT);

  // const context = {
  //   repo: { owner: process.env.GITHUB_OWNER, repo: "bicep-registry-modules" },
  // };
}

regenerateAllAsync();

// const scriptGenerateModuleIndexData = require(path.join(
//   process.cwd(),
//   "scripts/github-actions/generate-module-index-data.js"
// ));

// scriptGenerateModuleIndexData({ require, github, context, core }).then(() => {
//   const scriptGenerateModuleIndexMarkdown = require(path.join(
//     process.cwd(),
//     "scripts/github-actions/generate-module-index-md.js"
//   ));

//   scriptGenerateModuleIndexMarkdown({ require, github, context, core }).then(
//     () => {
//       console.info("Done.");
//     }
//   );
// });

//   const readmePaths = glob.sync(path.join(modulePath, "**", "README.md"));

//   for (const readmePath of readmePaths) {
//     const readmeContent = fs.readFileSync(readmePath, "utf8");
//     const updatedReadmeContent = readmeContent.replace(
//       /\/tree\/[a-zA-Z0-9.-]+\/modules\//g,
//       "/tree/main/modules/"
//     );
//     fs.writeFileSync(readmePath, updatedReadmeContent, "utf8");
//   }
// }

// function parseTag({ core, tag }) {
//   const segments = tag.split("/");

//   if (segments.length !== 3 || segments.includes("")) {
//     core.setFailed(
//       `Invalid tag: "${tag}". A valid tag must be in the format of "<ModuleFolder>/<ModuleName>/<ModuleVersion>".`
//     );
//   }

//   const modulePathSegmentRegex = /^[a-z0-9]+([._-][a-z0-9]+)*$/;
//   const moduleFolder = segments[0];
//   const moduleName = segments[1];

//   if (!modulePathSegmentRegex.test(moduleFolder)) {
//     core.setFailed(
//       `The module folder "${moduleFolder}" in the tag "${tag}" is invalid. It must match the regex "${modulePathSegmentRegex}".`
//     );
//   }

//   if (!modulePathSegmentRegex.test(moduleName)) {
//     core.setFailed(
//       `The module name "${moduleName}" in the tag "${tag}" is invalid. It must match the regex "${modulePathSegmentRegex}".`
//     );
//   }

//   const versionRegex =
//     /^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?$/;
//   const version = segments[2];

//   if (!versionRegex.test(version)) {
//     core.setFailed(
//       `The version "${version}" in the tag "${tag}" is invalid. It must match the regex "${versionRegex}".`
//     );
//   }

//   core.setOutput("module_path", `${moduleFolder}/${moduleName}`);
//   core.setOutput("version", version);

//   const readmeLink = `https://github.com/Azure/bicep-registry-modules/tree/${tag}/modules/${moduleFolder}/${moduleName}/README.md`;
//   core.setOutput("documentation_uri", readmeLink);
// }
