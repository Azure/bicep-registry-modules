// Run from repo root
const path = require("path");
const script = require(path.join(process.cwd(), "scripts/github-actions/generate-module-index-data.js"));

let core = {
    info: function(s) {
        console.warn(s);
    },
    setFailed: function(s) {
        throw s;
    }
};

script({ require, core })
