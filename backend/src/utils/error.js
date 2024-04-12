class HTTPException extends Error {
    constructor({ code, message, details }) {
        super(message);
        this.status_code = code;
        this.details = details;
    }
}

module.exports = {
    HTTPException
};