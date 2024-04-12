const express = require('express');
const logger = require('morgan');
const cookieParser = require('cookie-parser');
const session = require('express-session');
const cors = require('cors');
const process = require('node:process');
const crypto = require('crypto');
const expressJSDocSwagger = require('express-jsdoc-swagger');
const cookieSecret = crypto.randomBytes(128).toString('base64');
const { wrapResponse, STATUS_CODE } = require('./utils/response')

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
    baseDir: __dirname, //eslint-disable-line
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
        code: STATUS_CODE.HTTP_404_NOT_FOUND,
        error: 'Resource not Found'
    });
});

app.use(function (err, req, res, next) { // eslint-disable-line no-unused-vars
    if (err.status_code && err?.status_code !== STATUS_CODE.HTTP_500_INTERNAL_SERVER_ERROR) {
        return wrapResponse(res, {
            code: err.status_code,
            error: err.message,
            details: err.details
        });
    }
    return wrapResponse(res, {
        code: STATUS_CODE.HTTP_500_INTERNAL_SERVER_ERROR,
        error: err.message
    });
});

module.exports = {
    app,
    redisClient
};