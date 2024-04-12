const { IService } = require("../utils/service");

class DemoService extends IService {
    constructor(request) {
        super(request);
    }

    async index() {
        return "Hello, World!";
    }
}

module.exports = {
    DemoService
};