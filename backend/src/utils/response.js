const STATUS_CODE = Object.freeze({
    HTTP_200_OK: 200,
    HTTP_404_NOT_FOUND: 404,
    HTTP_500_INTERNAL_SERVER_ERROR: 500,
    HTTP_401_UNAUTHORIZED: 401,
    HTTP_403_FORBIDDEN: 403,
});

function wrapResponse(res, { code, message, error, data }) {
    return res.status(code).json({
        status_code: code,
        message,
        error,
        data
    });
}

module.exports = {
    STATUS_CODE,
    wrapResponse
};