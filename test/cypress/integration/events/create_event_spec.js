import { login } from '../../plugins/utils'

describe('Admin Events Spec', function () {
  beforeEach(() => {
    cy.appScenario('basic', {email: "test@test.cl", password: "12345678", username: "test", type: "admin"});
  })

  it('Draft event My events', function () {
    login()
    cy.visit("/events/mine")
    cy.contains("All Events")
    cy.contains("New event").click()
    cy.contains("Create Event")
    cy.get('input[name="event[title]"]')
    .clear()
    .type('my title')
    cy.get('textarea[name="event[description]"]')
    .clear()
    .type('foobar')
    cy.get('button[type="submit"]').click();
    cy.contains("Event created successfully")
    cy.visit("/events")
    cy.get('body')
    .should('not.have.value', 'my title')

    cy.visit("/events/mine")

    cy.contains("my title")

    cy.contains("Drafts").click()

    cy.contains("my title")

    cy.contains("Published").click()

    cy.get('body')
    .should('not.have.value', 'my title')

  })


  it.only('Published event My events', function () {
    login()
    cy.visit("/events/mine")
    cy.contains("All Events")
    cy.contains("New event").click()
    cy.contains("Create Event")
    cy.get('input[name="event[title]"]')
    .clear()
    .type('my title')
    cy.get('textarea[name="event[description]"]')
    .clear()
    .type('foobar')
    cy.get('button[type="submit"]').click();
    cy.contains("Event created successfully")
    
    cy.visit("/events/my-title/edit")

    cy.contains("Publish Event")
    cy.wait(4000)
    cy.contains("Publish Event").click()
    cy.wait(4000)
    cy.contains("Your event is published")

    cy.visit("/events")
    cy.get('body')
    .should('not.have.value', 'my title')

    cy.visit("/events/mine")

    cy.contains("my title")

    cy.contains("Published").click()

    cy.contains("my title")

    cy.contains("Drafts")
    cy.wait(2000)
    cy.contains("Drafts").click()
    cy.wait(2000)

    cy.get('body')
    .should('not.have.value', 'my title')

  })


})

describe.skip('User Events Spec', function () {
  beforeEach(() => {
    cy.appScenario('basic', {email: "test@test.cl", password: "12345678", username: "test"});
  })

  it('My events not allowed', function () {
    login()
    cy.visit("/events/mine")
    cy.contains("All Events")
  })
})