function getNextVersion(version) {
  const semver = require("semver");
  return semver.inc(version, "patch");
}

// Updates the module version references in the README.md file
async function updateReadmeExamplesAsync(modulePath, version) {
  const fs = require("fs");
  const path = require("path");
  const red = "\u001b[31m";
  const green = "\u001b[32m";
  const blue = "\u001b[34m";
  const yellow = "\u001b[33m";
  const reset = "\u001b[0m";

  console.log(`Updating README.md examples for ${modulePath}...`);

  const readmePath = path.join("./modules", modulePath, "README.md");
  const readmeContent = fs.readFileSync(readmePath, "utf8");

  const currentModulePath = `br/public:${modulePath}:${version}`;
  const nextModulePath = `br/public:${modulePath}:${getNextVersion(version)}`;

  const versionPattern = "[0-9.a-z]+";
  const anyRefPattern = `br/public:[a-z0-9-]+/[a-z0-9-]+:${versionPattern}`;

  // Look for unexpected versions
  let versions = Array.from(readmeContent.matchAll(anyRefPattern));
  versions = Array.from(new Set(versions.map((m) => m[0]))); // dedupe
  if (versions.length === 0) {
    console.warn(
      `${yellow}No module references found in ${readmePath}.${reset}`
    );
    return false;
  }

  const unexpectedVersions = versions.filter(
    (m) => m !== currentModulePath && m !== nextModulePath
  );
  if (unexpectedVersions.length > 0) {
    console.error(
      `... ${red}UNEXPECTED VERSIONS FOUND in ${readmePath}: ${unexpectedVersions}${reset}`
    );
    console.error(
      `...   Expected current version ${currentModulePath} or next version ${nextModulePath}${reset}`
    );
  }

  const updatedReadmeContent = readmeContent.replace(
    new RegExp(anyRefPattern, "g"),
    nextModulePath
  );
  if (updatedReadmeContent !== readmeContent) {
    console.log(
      `... ${green}Updated module references in README.md to ${nextModulePath}.${reset}`
    );
    fs.writeFileSync(readmePath, updatedReadmeContent, "utf8");
    return true;
  } else {
    console.log(
      `... ${blue}Module references in README.md are up-to-date.${reset}`
    );
    return false;
  }
}

exports.updateReadmeExamplesAsync = updateReadmeExamplesAsync;
