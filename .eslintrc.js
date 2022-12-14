module.exports = {
  env: {
    node: true,
    es2021: true,
  },
  parserOptions: {
    "sourceType": "module",
    ecmaVersion: "latest",
  },
  extends: ["eslint:recommended", "prettier"],
  rules: {
    "prefer-const": "error",
  },
};
