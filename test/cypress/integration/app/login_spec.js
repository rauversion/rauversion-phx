
import { login } from '../../plugins/utils'

describe('Login Spec', function () {
  beforeEach(() => {
    cy.appScenario('basic', {email: "test@test.cl", password: "12345678", username: "test"});
  })

  it('Sign in view', function () {
    login()
  })
})
