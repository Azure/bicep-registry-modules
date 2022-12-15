function getTimestamp() {
  const now = new Date();
  const year = now.getFullYear();
  const month = (now.getMonth() + 1).toString().padStart(2, "0");
  const date = now.getDate().toString().padStart(2, "0");
  const hours = now.getHours();
  const minutes = now.getMinutes();
  const seconds = now.getSeconds();

  return `${year}${month}${date}${hours}${minutes}${seconds}`;
}

async function createPullRequest(base, branchPrefix, contents, context, github, message, path, title) {
    const branch = `${this.branchPrefix}-${this.getTimestamp()}`;

    // Create a new branch.
    await this.github.rest.git.createRef({
      ...this.context.repo,
      ref: `refs/heads/${branch}`,
      sha: this.context.sha,
    });

    // Update file.
    const { data: treeData } = await this.github.rest.git.createTree({
      ...this.context.repo,
      tree: [
        {
          type: "blob",
          mode: "100644",
          path: this.path,
          content: this.contents,
        },
      ],
      base_tree: this.context.sha,
    });

    // Create a commit.
    const { data: commitData } = await this.github.rest.git.createCommit({
      ...this.context.repo,
      message: this.message,
      tree: treeData.sha,
      parents: [this.context.sha],
    });

    // Update HEAD of the new branch.
    await this.github.rest.git.updateRef({
      ...this.context.repo,
      // The ref parameter for updateRef is not the same as createRef.
      ref: `heads/${branch}`,
      sha: commitData.sha,
    });

    // Create a pull request.
    const { data: prData } = await this.github.rest.pulls.create({
      ...this.context.repo,
      title: this.title,
      head: branch,
      base: this.base,
      maintainer_can_modify: true,
    });

    return prData.html_url;
  }

  module.exports = createPullRequest;