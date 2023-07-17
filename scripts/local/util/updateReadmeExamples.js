const { readFileSync } = require("fs");

// Updates the module version references in the README.md file
function updateReadmeExamples(
  modulePath,
  currentVersion, // what the current version should be
  updateToVersion // update all versions to this
) {
  const fs = require("fs");
  const path = require("path");
  const red = "\u001b[31m";
  const green = "\u001b[32m";
  const blue = "\u001b[34m";
  const yellow = "\u001b[33m";
  const reset = "\u001b[0m";

  console.log(`Updating README.md examples for ${modulePath}...`);

  const readmePath = path.join("./modules", modulePath, "README.md");
  const readmeContent = readFileSync(readmePath, "utf8");

  const currentModulePath = `br/public:${modulePath}:${currentVersion}`;
  const nextModulePath = `br/public:${modulePath}:${updateToVersion}`;

  const versionPattern = "[0-9.a-z]+";
  const anyRefPattern = `br/public:${modulePath}:${versionPattern}`;

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
      currentModulePath == nextModulePath
        ? `...   Expected ${currentModulePath}`
        : `...   Expected either ${currentModulePath} or ${nextModulePath}${reset}`
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

exports.updateReadmeExamples = updateReadmeExamples;
