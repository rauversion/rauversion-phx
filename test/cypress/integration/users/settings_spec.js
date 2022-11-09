
import { login } from '../../plugins/utils'

describe('User Settings Spec', function () {
  beforeEach(() => {
    cy.appScenario('basic', {email: "test@test.cl", password: "12345678", username: "test"});
  })

  it('Settings Live View', function () {

    login();

    cy.visit('/users/settings');
    cy.contains('Username');

    // cy.get('input[name="user[email]"]')
    //   .type('test@test.cl')
    //   .should('have.value', 'test@test.cl');

    // cy.get('input[name="user[password]"]')
    //   .type('12345678')
    //   .should('have.value', '12345678');

    // cy.get('button[type="submit"]').click();

    // cy.get('body').should('contain', 'Logged in successfully.');
  })
})
