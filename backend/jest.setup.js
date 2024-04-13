/* eslint-disable */
const { downAll } = require('docker-compose/dist/v2');
require('dotenv').config({
    path: '.env.test'
});

process.env.ENVIRONMENT_NAME = 'test';
beforeEach(() => {
    process.env = { ...process.env, ENVIRONMENT_NAME: 'test' };
});
afterEach(() => {
    jest.clearAllMocks();
    jest.resetAllMocks();
    jest.resetModules();
});

afterAll(async () => {
    await downAll({
        cwd: __dirname + '/test_setup',
        log: true
    });
});