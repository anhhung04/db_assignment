const request = require('supertest');
const app = require('../src/server').app;

test("It should return Hello World", async () => {
    const res = await request(app).get('/api/demo');
    expect(res.statusCode).toEqual(200);
    expect(res.body).toEqual({
        status_code: 200,
        message: "Fetch data successfully",
        data: {
            message: "Hello, World!"
        }
    });
});