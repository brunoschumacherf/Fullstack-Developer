module.exports = {
  testEnvironment: "jsdom",
  roots: ["<rootDir>/app/frontend"],
  testMatch: ["**/__tests__/**/*.test.ts?(x)"],
  setupFilesAfterEnv: ["<rootDir>/app/frontend/test/setup.ts"],
  transform: {
    "^.+\\.[jt]sx?$": ["babel-jest", {
      presets: [
        ["@babel/preset-env", { targets: { node: "current" } }],
        ["@babel/preset-react", { runtime: "automatic" }],
        "@babel/preset-typescript",
      ],
    }],
  },
  clearMocks: true,
  // Inertia 3 exposes an import-only entry point; tests mock its browser boundary.
  moduleNameMapper: { "^@inertiajs/react$": "<rootDir>/node_modules/@inertiajs/react/dist/index.js" },
  collectCoverageFrom: ["app/frontend/{components,hooks}/**/*.{ts,tsx}", "!**/__tests__/**"],
  coverageDirectory: "coverage/frontend",
}
