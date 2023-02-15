
npm install -g @devcontainers/cli

repos = [
  "https://github.com/microsoft/unreal-cloud-on-azure",
  "https://github.com/microsoft/python-package-template",
  "https://github.com/microsoft/az-partner-center-cli",
  "https://github.com/microsoft/pytest-azure"
]

mkdir C:\git
cd C:\git

foreach ($repo in $repos)
{
  git clone $repo
}

foreach($file in ls)
{
  devcontainer build --workspace-folder $file
}
