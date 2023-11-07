#!/bin/sh

# See run-generate-module-index.js for instructions
# Must run from the root of the repo

node scripts/github-actions/runlocally/run-generate-module-index.js
pushd docs/jekyll
bundle exec jekyll build --baseurl $PWD/_site
popd
