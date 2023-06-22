const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    baseUrl: "https://911e4cqcrk.execute-api.eu-west-1.amazonaws.com/dev",
  },
  env: {
    apiEndpoint: process.env.apiEndpoint
  },
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
});
