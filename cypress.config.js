module.exports = {
  animationDistanceThreshold: 5,
  blockHosts: null,
  chromeWebSecurity: true,
  defaultCommandTimeout: 5000,
  env: {},
  execTimeout: 12000,
  fileServerFolder: '',
  fixturesFolder: './test/cypress/fixtures',
  hosts: null,
  modifyObstructiveCode: true,
  numTestsKeptInMemory: 50,
  pageLoadTimeout: 60000,
  port: null,
  projectId: '6xt2sd',
  reporterOptions: null,
  requestTimeout: 15000,
  responseTimeout: 30000,
  screenshotsFolder: './test/cypress/screenshots',
  taskTimeout: 60000,
  trashAssetsBeforeRuns: true,
  userAgent: null,
  video: true,
  videoCompression: 32,
  videoUploadOnPasses: true,
  videosFolder: './test/cypress/videos',
  viewportHeight: 660,
  viewportWidth: 1000,
  waitForAnimations: true,
  watchForFileChanges: true,
  e2e: {
    // We've imported your old cypress plugins here.
    // You may want to clean this up later by importing these.
    setupNodeEvents(on, config) {
      return require('./test/cypress/plugins')(on, config)
    },
    specPattern: './test/cypress/integration//**/*.*',
    baseUrl: 'http://localhost:4002',
    excludeSpecPattern: '*.hot-update.js',
    supportFile: './test/cypress/support',
  },
}
