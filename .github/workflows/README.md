# Module checks and releases

The shared [PR check](./pr-check.yml) discovers affected modules and runs their checks when a PR is opened, reopened or updated. Add the `PR: Run E2E Tests` label when deployment tests are needed for a same-repository PR. Fork PRs do not run deployment tests through this label; coordinate an authorized run with a maintainer.

The shared [release workflow](./release.yml) discovers pending module releases, checks the changelog and requires approval through `publish-approval` before creating scoped release tags. It can be started manually. Its planned `main` push trigger is currently disabled; automatic tagging resumes when that trigger is enabled. Registry publication is a separate process, so verify the published version after the tag is created.

For local authoring and checks, install `Avm.Authoring` from MAR using the [Bicep prerequisites](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/prerequisites/) and follow the [local validation guide](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/validate-bicep-module-locally/).
