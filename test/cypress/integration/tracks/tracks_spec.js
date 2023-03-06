import { login, expectPlayingAudio } from '../../plugins/utils';

describe('Tracks Spec', function () {

  beforeEach(() => {
    cy.appScenario('artist', {email: "test@test.cl", password: "12345678", username: "test"});
    /*cy.appEval(`
      Chaskiq.Integrations.Catalog.import_all
    `);*/
    // cy.viewport(1024, 768)
  });

  it.only('Access & upload tracks', function () {
    login();

    cy.get('[data-cy="mobile-dropdown-toggle"]').click()
    cy.get('a').contains('My Music').click({force: true})
    cy.contains("Albums")
    cy.contains("Playlists")
    cy.wait(2000)
    cy.contains("New Track").click()
    cy.get('input[type=file]')
    .selectFile('test/cypress/fixtures/example.json', {
      force: true,
      action: 'drag-drop'
    })
    cy.get('input[type=file]').trigger("change", {force: true})

    cy.contains("Not accepted")
    cy.get('input[type=file]').selectFile('test/cypress/fixtures/sample-3s.mp3', {force: true, action: 'drag-drop'})
    cy.get('input[type=file]').trigger("change", {force: true})

    cy.contains("Continue").click()
    cy.contains("Save").click()
    cy.wait(16000)
    cy.contains("Go to your track").click()
    cy.contains("sample-3s.mp3")
    cy.get('[data-audio-target="play"]').click()
    expectPlayingAudio()
    cy.get('textarea').type('foo').should('have.value', 'foo');
    cy.get('button[data-cy="comment-submit"]').click()
    cy.contains("Commented")
    cy.contains("foo")
    cy.contains("0 Like").click()
    cy.contains("1 Like").click()
    cy.contains("0 Like")
    cy.get('a[data-cy="tracks-back"]').click()
    cy.wait(5000)
    cy.contains('Your insights').click()
    cy.contains("plays 1")
    cy.contains("Tracks")
    cy.get('[data-cy="profile-menu-Tracks"]').click()
  })
});


describe('User Tracks access', function () {
  beforeEach(() => {
    cy.appScenario('basic', {email: "test@test.cl", password: "12345678", username: "test"});
  })

  it('Upload not allowed, non artists', function () {
    login()
    cy.visit("/tracks/new")
    cy.contains("Tracks uploads are not allowed on your account type")
  })
});
