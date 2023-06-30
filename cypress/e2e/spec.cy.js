describe('API Gateway Tests', () => {
  // const myEndpoint = Cypress.env('apiEndpoint');

  it('should retrieve the count via GET request', () => {
    cy.request({
      method: 'GET',
      url: '/',
      failOnStatusCode: false, // Prevent Cypress from failing the test on non-2xx status codes
    })
    .then((response) => {
      expect(response.status).to.eq(200);
      expect(response.redirectedToUrl).to.be.undefined;
      expect(response.body).to.have.property('hit_count').that.is.a('number');
      expect(response.body).to.have.property('hashed_ip_count').that.is.a('number');
    });
  });

  it('should increment the count via POST request', () => {
    cy.request({
      method: 'POST',
      url: '/',
      failOnStatusCode: false,
    })
    .then((response) => {
      expect(response.status).to.eq(200);
      expect(response.redirectedToUrl).to.be.undefined;
      expect(response.body).to.satisfy((body) => {
        return (
          body.message === 'IP address already exists' ||
          body.message === 'Hashed IP address stored successfully'
        );
      });
    });
  });
});