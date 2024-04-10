const router = require('express').Router();
const { index } = require("../services/demo");

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
router.get('/', index);

module.exports = router;