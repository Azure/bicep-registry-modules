/**
 * @param {typeof import("fs")} fs
 * @param {string} dir
 */
function getSubdirNames({ fs, dir}) {
  return fs
    .readdirSync(dir, { withFileTypes: true })
    .filter((x) => x.isDirectory())
    .map((x) => x.name);
}

module.exports = getSubdirNames;
