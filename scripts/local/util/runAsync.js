let runAll = false;

const { exec } = require("child_process");
const { promisify } = require("util");
const { yellow, red, reset } = require("./colors");

const execPromise = promisify(exec);

async function runAsync(cmd, echo = true) {
  if (echo) {
    console.log(`${yellow}${cmd}${reset}`);
  }

  const response = await execPromise(cmd, {});
  if (echo) {
    console.log(`> ${response.stdout}`);
  }
  return response.stdout;
}

function queryUserAsync(question) {
  const readline = require("readline").createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  return new Promise((resolve) => {
    readline.question(question, (answer) => {
      readline.close();
      resolve(answer);
    });
  });
}

async function queryRunAsync(cmds, optionalFriendlyPrompt) {
  cmds = typeof cmds === "string" ? [cmds] : cmds;
  let run = runAll === true;
  if (!run) {
    const prompt =
      `${red}` +
      (optionalFriendlyPrompt ??
        `Run the following commands?\n${yellow}${cmds.join("\n")}${reset}?`);
    const answer = await queryUserAsync(
      `${reset}${prompt} ${red}(y/n/a/q)${reset}`
    );
    console.log(`answer: ${answer}`);

    if (answer === "y") {
      run = true;
    } else if (answer === "a") {
      runAll = true;
      run = true;
    } else if (answer === "q") {
      throw new Error("User aborted");
    }
  }

  if (run) {
    for (const cmd of cmds) {
      await runAsync(cmd);
    }

    return true;
  } else {
    return false;
  }
}

exports.runAsync = runAsync;
exports.queryRunAsync = queryRunAsync;
exports.queryUserAsync = queryUserAsync;
exports.runAll = runAll;
