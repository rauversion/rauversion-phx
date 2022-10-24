// ***********************************************************
// This example support/index.js is processed and
// loaded automatically before your test files.
//
// This is a great place to put global configuration and
// behavior that modifies Cypress.
//
// You can change the location of this file or turn off
// automatically serving support files with the
// 'supportFile' configuration option.
//
// You can read more here:
// https://on.cypress.io/configuration
// ***********************************************************

// Import commands.js using ES2015 syntax:

// import 'cypress-xpath'

// CypressOnRails: dont remove these command
Cypress.Commands.add('appCommands', function (body) {
  cy.log('APP: ' + JSON.stringify(body));
  cy.request({
    method: 'POST',
    url: '/__cypress__/command',
    body: JSON.stringify(body),
    log: true,
    failOnStatusCode: true,
  }).then((response) => {
    return response.body;
  });
});

Cypress.Commands.add('app', function (name, command_options) {
  return cy
    .appCommands({ name: name, options: command_options })
    .then((body) => {
      return body[0];
    });
});

Cypress.Commands.add('appScenario', function (name, options = {}) {
  return cy.app('scenarios/' + name, options);
});

Cypress.Commands.add('appEval', function (code) {
  return cy.app('eval', code);
});

Cypress.Commands.add('appFactories', function (options) {
  return cy.app('factory_bot', options);
});

Cypress.Commands.add('appFixtures', function (options) {
  cy.app('activerecord_fixtures', options);
});
// CypressOnRails: end

// The next is optional
beforeEach(() => {
  cy.app('clean'); // have a look at cypress/app_commands/clean.rb
});

// comment this out if you do not want to attempt to log additional info on test fail
Cypress.on('fail', (err, runnable) => {
  // allow app to generate additional logging data
  Cypress.$.ajax({
    url: '/__cypress__/command',
    data: JSON.stringify({
      name: 'log_fail',
      options: {
        error_message: err.message,
        runnable_full_title: runnable.fullTitle(),
      },
    }),
    async: false,
    method: 'POST',
  });

  throw err;
});

// Alternatively you can use CommonJS syntax:
// require('./commands')

const resizeObserverLoopErrRe = /^ResizeObserver loop limit exceeded/

/*
Cypress.on('uncaught:exception', (err) => {
  if (resizeObserverLoopErrRe.test(err.message)) {
    // returning false here prevents Cypress from
    // failing the test
    return false
  }
}) */

Cypress.on('uncaught:exception', (err, runnable) => {
  return false
})
