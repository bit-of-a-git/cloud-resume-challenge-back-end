describe('API Gateway Tests', () => {
  const myEndpoint = "http://911e4cqcrk.execute-api.eu-west-1.amazonaws.com/dev";

  it('should retrieve the count via GET request', () => {
      cy.request('GET', myEndpoint) // Replace with your actual GET endpoint
      .its('body')
      .should('be.a', 'number');
  });

  it('should increment the count via POST request', () => {
      cy.request('POST', myEndpoint) // Replace with your actual POST endpoint
      .its('body')
      .should('eq', 'Records added successfully.');
  });
});