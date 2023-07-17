#!/bin/sh
# You must run this from the repo root

node scripts/github-actions/test/test-generate-module-index.js
pushd docs/jekyll
bundle exec jekyll build --baseurl $PWD/_site
popd
