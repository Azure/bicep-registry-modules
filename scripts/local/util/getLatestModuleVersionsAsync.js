const { runAsync } = require("./runAsync.js");

function parseTag(tag) {
  const parseTagScript = require("../../github-actions/parse-tag.js");

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

async function getLatestModuleVersionsAsync() {
  const tags = (await runAsync(`git tag -l`))
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

exports.getLatestModuleVersionsAsync = getLatestModuleVersionsAsync;
