
import { login } from '../../plugins/utils'

describe('User Settings Spec', function () {
  beforeEach(() => {
    cy.appScenario('basic', {email: "test@test.cl", password: "12345678", username: "test"});
  })

  it('Settings Live View', function () {

    login();

    cy.visit('/users/settings');
    cy.contains('Username');

    cy.get('input[name="user[username]"]')
      .should('have.value', 'test')

    cy.get('input[name="user[username]"]')
      .clear()
      .type('test-username')

    cy.get('input[name="user[first_name]"]')
      .type('Test First Name')

    cy.get('input[name="user[last_name]"]')
      .type('Test Last Name')

    cy.get('input[name="user[country]"]')
      .type('Chile')

    cy.get('input[name="user[city]"]')
      .type('Quilpué')

    cy.get('textarea[name="user[bio]"]')
      .type('A rockstar from Chile')

    /*cy.get('input[name="avatar"]')
      .selectFile('test/cypress/fixtures/avatar.png', {force: true})*/

    /*cy.get('input[name="profile_header"]')
      .selectFile('test/cypress/fixtures/cover.png', {force: true})*/

    cy.get('button[type="submit"]').click();

    cy.contains('updated successfully');

    cy.get('input[name="user[username]"]')
      .should('have.value', 'test-username')

    cy.get('input[name="user[first_name]"]')
    .should('have.value', 'Test First Name')

    cy.get('input[name="user[last_name]"]')
    .should('have.value', 'Test Last Name')

    cy.get('input[name="user[country]"]')
    .should('have.value', 'Chile')

    cy.get('input[name="user[city]"]')
    .should('have.value', 'Quilpué')

    cy.get('textarea[name="user[bio]"]')
    .should('have.value', 'A rockstar from Chile')

  })
})
