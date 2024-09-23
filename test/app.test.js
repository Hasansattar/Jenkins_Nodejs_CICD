const request = require('supertest');
const { app, server } = require('../app');

describe('GET /', () => {
    afterAll(() => {
        server.close();  // Close the server after tests
    });

    it('should return "Hello, Jenkins Pipeline!"', async () => {
        const res = await request(app).get('/');
        expect(res.statusCode).toEqual(200);
        expect(res.text).toBe('Hello, Jenkins Pipeline!');
    });
});
