const reEmail = new RegExp('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$');
const reUUID = new RegExp('^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');

class Email extends String {
    [Symbol.hasInstance](instance) {
        return reEmail.test(instance);
    }
}

class UUID extends String {
    [Symbol.hasInstance](instance) {
        return reUUID.test(instance);
    }
}

module.exports = {
    Email,
    UUID
};