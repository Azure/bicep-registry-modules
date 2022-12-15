async function createPullRequest(base, branchPrefix, contents, context, github, message, path, title) {
    const branch = `${branchPrefix}-${getTimestamp()}`;

    // Create a new branch.
    await github.rest.git.createRef({
      ...context.repo,
      ref: `refs/heads/${branch}`,
      sha: context.sha,
    });

    // Update file.
    const { data: treeData } = await github.rest.git.createTree({
      ...context.repo,
      tree: [
        {
          type: "blob",
          mode: "100644",
          path: path,
          content: contents,
        },
      ],
      base_tree: context.sha,
    });

    // Create a commit.
    const { data: commitData } = await github.rest.git.createCommit({
      ...context.repo,
      message: message,
      tree: treeData.sha,
      parents: [context.sha],
    });

    // Update HEAD of the new branch.
    await github.rest.git.updateRef({
      ...context.repo,
      // The ref parameter for updateRef is not the same as createRef.
      ref: `heads/${branch}`,
      sha: commitData.sha,
    });

    // Create a pull request.
    const { data: prData } = await github.rest.pulls.create({
      ...context.repo,
      title: title,
      head: branch,
      base: base,
      maintainer_can_modify: true,
    });

    return prData.html_url;
  }

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
  
  module.exports = createPullRequest;