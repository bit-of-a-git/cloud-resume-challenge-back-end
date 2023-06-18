const { defineConfig } = require("cypress");

module.exports = defineConfig({
  env: {
    apiEndpoint: process.env.API_ENDPOINT
  },
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
});
