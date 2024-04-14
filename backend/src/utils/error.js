class HTTPException extends Error {
    constructor({ code, message, details, err }) {
        super(message);
        this.status_code = code;
        this.details = details;
        this.error = err;
    }
}

module.exports = {
    HTTPException
};