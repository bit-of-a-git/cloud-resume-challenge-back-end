const { defineConfig } = require("cypress");

module.exports = {
  env: {
    apiEndpoint: process.env.apiEndpoint,
  },
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
};
