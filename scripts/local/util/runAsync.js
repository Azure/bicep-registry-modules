const { exec } = require("child_process");
const { promisify } = require("util");
const { yellow, reset } = require("./colors");

const execPromise = promisify(exec);

async function runAsync(cmd, echo = true) {
  if (echo) {
    console.log(`${yellow}${cmd}${reset}`);
  }

  const response = await execPromise(cmd);
  if (echo) {
    console.log(`> ${response.stdout}`);
  }
  return response.stdout;
}

exports.runAsync = runAsync;
