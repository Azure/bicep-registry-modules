#!/bin/sh
# You must run this from the repo root

node scripts/github-actions/test/test-publish-module-index.js
pushd docs/jekyll
bundle exec jekyll build --baseurl $PWD/_site
popd
