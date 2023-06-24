describe('API Gateway Tests', () => {
  // const myEndpoint = Cypress.env('apiEndpoint');

  it('should retrieve the count via GET request', () => {
      cy.request('GET', '/') // Replace with your actual GET endpoint
      .its('body')
      .should('be.a', 'number');
  });

  it('should increment the count via POST request', () => {
      cy.request('POST', '/') // Replace with your actual POST endpoint
      .its('body')
      .should('eq', 'Records added successfully.');
  });
});