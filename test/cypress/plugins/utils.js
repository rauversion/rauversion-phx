export function translations() {
  cy.appEval(`
    a = Chaskiq.Apps.last_app |> Chaskiq.Apps.update_app(%{
      translations: %{
        es: %{
          greetings: "Hola amigo",
          tagline: "estamos aqui para ayudarte",
          intro: "somos un equipo genial"
        },
        en: %{
          greetings: "hello friend",
          tagline: "we are here to help",
          intro: "we are an awesome team"
        }
      }
    })
    1
  `);
}

export function login() {
  cy.visit('/users/log_in');
  cy.contains('Sign in');

  cy.get('input[name="user[email]"]')
    .type('test@test.cl')
    .should('have.value', 'test@test.cl');

  cy.get('input[name="user[password]"]')
    .type('12345678')
    .should('have.value', '12345678');

  cy.get('button[type="submit"]').click();

  cy.get('body').should('contain', 'Logged in successfully.');
}

export function findButtonByName(name) {
  return cy.get('button').contains(name);
}

export function findElementByName(element, name) {
  return cy.get(element).contains(name);
}

export function findLinkByName(name) {
  return cy.get('a').contains(name);
}

export const getIframeDocument = (iframe) => {
  return (
    cy
      .get(iframe)
      // Cypress yields jQuery element, which has the real
      // DOM element under property "0".
      // From the real DOM iframe element we can get
      // the "document" element, it is stored in "contentDocument" property
      // Cypress "its" command can access deep properties using dot notation
      // https://on.cypress.io/its
      .its('0.contentDocument')
      .should('exist')
  );
};

export const getIframeBody = (iframe) => {
  // get the document
  return (
    getIframeDocument(iframe)
      // automatically retries until body is loaded
      .its('body')
      .should('not.be.undefined')
      // wraps "body" DOM element to allow
      // chaining more Cypress commands, like ".find(...)"
      .then(cy.wrap)
  );
};

export const expectPlayingAudio = () => {
  cy.get('audio,video').should((els)=>{
    let audible = false
    els.each((i, el)=>{
      console.log(el)
      console.log(el.duration, el.paused, el.muted)
      if (el.duration > 0 && !el.paused && !el.muted) {
        audible = true
      }

      // expect(el.duration > 0 && !el.paused && !el.muted).to.eq(false)
    })
    expect(audible).to.eq(true)
  })
}
