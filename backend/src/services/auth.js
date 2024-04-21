const { IService } = require("../utils/service");
const { UserRepo } = require("../repository/user");
const bcrypt = require("bcrypt");

class AuthService extends IService {
    /**
     * Initialize auth service
     * @param {Request} request
     */
    constructor(request) {
        super(request);
        this.userRepo = new UserRepo();
    }

    /**
     * Login user
     * @param {Object} data
     * @param {string} data.username
     * @param {string} data.password
     * @param {string} data.email
     */
    async login({ username, password, email }) {
        const { user, error } = await this.userRepo.find({
            username,
            email
        });
        if (error) {
            throw new Error(error);
        }
        if (!user || !(await bcrypt.compare(password, user.password))) {
            return null;
        }
        delete user.password;
        return user;
    }
    /**
     * Register user
     * @param {Object} data
     * @param {string} data.username
     * @param {string} data.password
     * @param {string} data.email
     * @param {string} data.phone_no
     * @param {string} data.address
     * @param {string} data.avatar_url
     * @param {Date} data.birthday
     * @param {string} data.fname
     * @param {string} data.lname
     * @returns {Promise<import("../typedef/user").User>}
     */
    async register({
        username,
        password,
        email,
        phone_no,
        address,
        avatar_url,
        birthday,
        fname,
        lname
    }) {
        const { user, error } = await this.userRepo.create({
            username,
            password: await bcrypt.hash(password, 10),
            email,
            phone_no,
            address,
            avatar_url,
            birthday,
            fname,
            lname
        });
        if (error) {
            throw new Error(error);
        }
        return user;
    }
}

module.exports = {
    AuthService
};