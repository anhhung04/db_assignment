const express = require('express');
const logger = require('morgan');
const cookieParser = require('cookie-parser');
const session = require('express-session');
const cors = require('cors');
const process = require('node:process');
const __dirname = process.cwd();
const crypto = require('crypto');
const expressJSDocSwagger = require('express-jsdoc-swagger');
const cookieSecret = crypto.randomBytes(128).toString('base64');
const { HTTP_404_NOT_FOUND, HTTP_500_INTERNAL_SERVER_ERROR } = require('./utils/code');
const { wrapResponse } = require('./utils/response')

const redis = require('redis');
const RedisStore = require('connect-redis').default;
const redisClient = redis.createClient({
    url: process.env.REDIS_URL || 'redis://redis:6379'
});

require('dotenv').config();
const app = express();
const mainRoute = require('./routes');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser(cookieSecret));

app.use(cors());

app.use(session({
    secret: cookieSecret,
    resave: false,
    saveUninitialized: false,
    cookie: {
        secure: process.env.NODE_ENV === 'production',
        httpOnly: true,
        maxAge: 1000 * 60 * 60,
    },
    store: new RedisStore({
        client: redisClient,
        prefix: 'session:',
    }),
}));

expressJSDocSwagger(app)({
    info: {
        version: '1.0.0',
        title: 'API Documentation',
        description: 'API Documentation',
    },
    filesPattern: './**/*.js',
    baseDir: __dirname,
    security: {
        CookieAuth: {
            type: 'apiKey',
            in: 'cookie',
            name: 'connect.sid',
        }
    },
    swaggerUIPath: '/api/docs',
    
})

app.use('/api', mainRoute);

app.all('*', (req, res) => {
    return wrapResponse(res, {
        code: HTTP_404_NOT_FOUND,
        error: 'Not Found'
    });
});

app.use(function (err, req, res, next) { // eslint-disable-line no-unused-vars
    return wrapResponse(res, {
        code: HTTP_500_INTERNAL_SERVER_ERROR,
        error: err.message
    });
});

module.exports = {
    app,
    redisClient
};