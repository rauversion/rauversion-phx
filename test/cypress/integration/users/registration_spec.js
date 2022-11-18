
import { login } from '../../plugins/utils'

describe('Registration Spec', function () {
  beforeEach(() => {
    //cy.appScenario('basic', {email: "test@test.cl", password: "12345678", username: "test"});
  })

  it('Sign in view', function () {
    cy.visit("/users/register")

    cy.get('input[name="user[username]"]')
      .clear()
      .type('test-username')

    cy.get('input[name="user[email]"]')
      .clear()
      .type('test@test.com')

    cy.get('input[name="user[password]"]')
      .clear()
      .type('12345678')

    cy.get('button[type="submit"]').click();

    cy.contains("Logged in successfully")

    cy.appEval(`
      Rauversion.Accounts.get_user_by_email("test@test.com").type
    `).then((a)=> {
      expect(a.data).to.be.equal('user')
     });
  })
})