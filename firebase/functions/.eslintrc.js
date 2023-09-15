module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "google",
    "plugin:@typescript-eslint/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: ["tsconfig.json", "tsconfig.dev.json"],
    sourceType: "module",
    tsconfigRootDir: __dirname,
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
  ],
  plugins: [
    "@typescript-eslint",
    "import",
  ],
  rules: {
    "import/no-unresolved": 0,
    "indent": ["error", 2],
    "linebreak-style": 0,
    "semi": "off",
    "object-curly-spacing": "off",
    "curly": "off",
    "quotes": 'off',
    "max-len": "off",
    "jsdoc/require-jsdoc": "off",
    "require-jsdoc": 0,
    "space-before-blocks": "off",
    "keyword-spacing": "off",
    "space-after-keywords": "off",
    /** turn these on to clean up before shipping */
    // "import/no-commonjs": "off",
    "warning": "off",
    "no-unused-vars": "off",
    "no-unused-functions": "off",
  },
};
