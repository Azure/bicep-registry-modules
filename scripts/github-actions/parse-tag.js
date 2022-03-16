/**
 * @typedef Params
 * @property {typeof import("@actions/core")} core
 * @property {string} tag
 *
 * @param {Params} params
 */
function parseTag({ core, tag }) {
  const segments = tag.split("/");

  if (segments.length !== 3 || segments.includes("")) {
    core.setFailed(
      `Invalid tag: "${tag}". A valid tag must be in the format of "<ModuleFolder>/<ModuleName>/<ModuleVersion>".`
    );
  }

  const modulePathSegmentRegex = /^[a-z0-9]+([._-][a-z0-9]+)*$/;
  const moduleFolder = segments[0];
  const moduleName = segments[1];

  if (!modulePathSegmentRegex.test(moduleFolder)) {
    core.setFailed(
      `The module folder "${moduleFolder}" in the tag "${tag}" is invalid. It must match the regex "${modulePathSegmentRegex}".`
    );
  }

  if (!modulePathSegmentRegex.test(moduleName)) {
    core.setFailed(
      `The module name "${moduleName}" in the tag "${tag}" is invalid. It must match the regex "${modulePathSegmentRegex}".`
    );
  }

  const versionRegex =
    /^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?$/;
  const version = segments[2];

  if (!versionRegex.test(version)) {
    core.setFailed(
      `The version "${version}" in the tag "${tag}" is invalid. It must match the regex "${versionRegex}".`
    );
  }

  core.setOutput("module_path", `${moduleFolder}/${moduleName}`);
  core.setOutput("version", version);
}

module.exports = parseTag;
