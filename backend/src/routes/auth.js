const router = require('express').Router();
const { AuthService } = require('../services/auth');
const { wrapResponse, STATUS_CODE, saveSession } = require('../utils/http');
const { HTTPException } = require('../utils/error');

router.use(async (req, _, next) => {
    req.authService = new AuthService(req);
    try {
        let startSuccess = await req.authService.start();
        if (!startSuccess) {
            throw new HTTPException({
                code: STATUS_CODE.HTTP_500_INTERNAL_SERVER_ERROR,
                message: "Start service error",
            });
        }
        next();
    } catch (err) {
        next(err);
    }
});

/**
 * Login response
 * @typedef {object} LoginResponse
 * @property {Boolean} success - Login status
 */
/**
 * WrapResponse
 * @typedef {object} WrapResponseLogin
 * @property {number} status_code - HTTP status code
 * @property {string} message - Message to be response if exists
 * @property {LoginResponse} data - Express response object
 */
/**
 * POST /api/auth/login
 * @summary Login route
 * @tags auth
 * @param {object} body.body.required - Login body
 * @param {string} body.username - Username
 * @param {string} body.email - Email
 * @param {string} body.password.required - Password
 * @return {WrapResponseLogin} 200 - success response - application/json
 * @example response - 200 - success response example
 * {
 *  "status_code": 200,
 *  "message": "Login successfully",
 *  "data": {
 *      "success": true
 *  }
 * }
 */
router.post('/login', async (req, res, next) => {
    try {
        const { username, password, email } = req.body;
        /**
         * @type {AuthService}
         */
        const authService = req.authService;
        const user = await authService.login({ username, password, email });
        if (!user) {
            throw new HTTPException({
                code: STATUS_CODE.HTTP_401_UNAUTHORIZED,
                message: "Invalid username or password",
                data: {
                    success: false
                }
            });
        }
        await saveSession(req, { user });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Login successfully",
            data: {
                success: true
            }
        });
    } catch (err) {
        next(err);
    }
});

/**
 * Register response
 * @typedef {object} RegisterResponse
 * @property {Boolean} success - Register status
 */
/**
 * WrapResponse
 * @typedef {object} WrapResponseRegister
 * @property {number} status_code - HTTP status code
 * @property {string} message - Message to be response if exists
 * @property {RegisterResponse} data - Express response object
 */
/**
 * POST /api/auth/register
 * @summary Login route
 * @tags auth
 * @param {object} body.body.required - Register body
 * @param {string} body.username.required - Username
 * @param {string} body.password.required - Password
 * @param {string} body.email.required - Email
 * @param {string} body.phone_no.required - Phone number
 * @param {string} body.address.required - Address
 * @param {string} body.avatar_url.required - Avatar URL
 * @param {string} body.birthday.required - Birthday
 * @param {string} body.fname.required - First name
 * @param {string} body.lname.required - Last name
 * @return {WrapResponseRegister} 200 - success response - application/json
 * @example response - 200 - success response example
 * {
 *  "status_code": 200,
 *  "message": "Register successfully",
 *  "data": {
 *      "success": true
 *  }
 * }
 */
router.post('/register', async (req, res, next) => {
    try {
        const {
            username,
            password,
            email,
            phone_no,
            address,
            avatar_url,
            birthday,
            fname,
            lname
        } = req.body;
        /**
         * @type {AuthService}
         */
        const authService = req.authService;
        const user = await authService.register({
            username,
            password,
            email,
            phone_no,
            address,
            avatar_url,
            birthday,
            fname,
            lname
        });
        if (!user) {
            throw new HTTPException({
                code: STATUS_CODE.HTTP_400_BAD_REQUEST,
                message: "Register failed!",
                data: {
                    success: false
                }
            });
        }
        await authService.logActivity({
            action: "create",
            resourceId: user.id,
            note: `User ${user.username} registered`
        });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Register successfully",
            data: {
                success: true
            }
        });
    } catch (err) {
        next(err);
    }
});
/**
 * WrapResponse
 * @typedef {object} WrapResponseMe
 * @property {number} status_code - HTTP status code
 * @property {string} message - Message to be response if exists
 * @property {import("../typedef/user").User} data - Express response object
 */
/**
 * GET /api/auth/me
 * @summary Get current user
 * @tags auth
 * @return {WrapResponseMe} 200 - success response - application/json
 * @example response - 200 - success response example
 */
router.get("/me", async (req, res, next) => {
    try {
        const user = req.session?.user;
        if (!user) {
            throw new HTTPException({
                code: STATUS_CODE.HTTP_401_UNAUTHORIZED,
                message: "Unauthorized",
            });
        }
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            data: user
        });
    } catch (err) {
        next(err);
    }
});

module.exports = router;