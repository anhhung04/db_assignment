const { wrapResponse } = require('../utils/response');
const { HTTP_200_OK } = require("../utils/code");

function index(req, res) {
    return wrapResponse(res, {
        code: HTTP_200_OK,
        message: "Fetch data successfully",
        data: {
            message: "Hello, World!"
        }
    });
}

module.exports = {
    index
};