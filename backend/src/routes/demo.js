const router = require('express').Router();
const { DemoService } = require("../services/demo");
const { wrapResponse, STATUS_CODE } = require('../utils/http');

router.use((req, _, next) => {
    req.service = new DemoService(req);
    next();
});

/**
 * Demo response
 * @typedef {object} DemoResponse
 * @property {string} message - Message to be response if exists
 */
/**
 * WrapResponse
 * @typedef {object} WrapResponse
 * @property {number} status_code - HTTP status code
 * @property {string} message - Message to be response if exists
 * @property {DemoResponse} data - Express response object
 */
/**
 * GET /api/demo
 * @summary This is demo route
 * @tags demo
 * @return {WrapResponse} 200 - success response - application/json
 * @example response - 200 - success response example
 * {
 *  "status_code": 200,
 *  "message": "Fetch data successfully",
 *  "data": {
 *      "message": "Hello, World!"
 *  }
 * }
 */
router.get('/', async (req, res, next) => {
    /**
     * @type {DemoService}
     */
    try {
        const service = req.service;
        let result = await service.index();
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Fetch data successfully",
            data: {
                message: result
            }
        });
    } catch (err) {
        next(err);
    }
});

module.exports = router;