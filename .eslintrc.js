module.exports = {
  env: {
    node: true,
    es2021: true,
  },
  parserOptions: {
    ecmaVersion: "latest",
  },
  extends: ["eslint:recommended", "prettier"],
  rules: {
    "prefer-const": "error",
  },
};
