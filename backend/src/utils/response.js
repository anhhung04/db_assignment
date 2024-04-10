function wrapResponse(res, { code, message, error, data }) {
    return res.status(code).json({
        status_code: code,
        message,
        error,
        data
    });
}

module.exports = {
    wrapResponse
};