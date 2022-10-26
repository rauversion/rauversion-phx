import { login, expectPlayingAudio } from '../../plugins/utils';

describe('Tracks Spec', function () {
  beforeEach(() => {
    cy.appScenario('artist', {email: "test@test.cl", password: "12345678", username: "test"});
    /*cy.appEval(`
      Chaskiq.Integrations.Catalog.import_all
    `);*/
  });

  it('Access & upload tracks', function () {
    login();

    cy.get('[data-cy="mobile-dropdown-toggle"]').click()
    cy.get('a').contains('My Tracks').click({force: true})
    cy.contains("Albums")
    cy.contains("Playlists")
    cy.contains("New Track").click()

    cy.get('input[type=file]').selectFile('test/cypress/fixtures/example.json', {force: true})
    cy.contains("Not accepted")

    cy.get('input[type=file]').selectFile('test/cypress/fixtures/sample-3s.mp3', {force: true})
    cy.contains("Continue").click()
    cy.contains("Save").click()
    cy.wait("3000")
    cy.contains("Go to your track").click()
    cy.contains("sample-3s.mp3")
    cy.get('[data-audio-target="play"]').click()

    expectPlayingAudio()
  })
});
