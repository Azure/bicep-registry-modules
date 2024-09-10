#!/bin/bash -e
GH_RUNNER_VERSION=$1
TARGETPLATFORM=$2

export TARGET_ARCH="x64"
if [[ $TARGETPLATFORM == "linux/arm64" ]]; then
  export TARGET_ARCH="arm64"
fi

if [[ $GH_RUNNER_VERSION == "" ]]; then
  LASTEST_VERSION=$(curl "https://api.github.com/repos/actions/runner/releases/latest")
  GH_RUNNER_VERSION=$(echo $LASTEST_VERSION | jq -r '.tag_name')
  echo "GitHub Runner latest version: $GH_RUNNER_VERSION"
fi

ReplaceWith=""
GH_RUNNER_VERSION=${GH_RUNNER_VERSION/v/${ReplaceWith}}

curl -L "https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-${TARGET_ARCH}-${GH_RUNNER_VERSION}.tar.gz" > actions.tar.gz
tar -zxf actions.tar.gz
rm -f actions.tar.gz
./bin/installdependencies.sh
mkdir /_work
