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

    async login({ username, password, email }) {
        const { row: checkUser, error } = await this.userRepo.findOneInTable({
            table: "users",
            findObj: {
                username,
                email
            }
        });
        if (error) {
            throw new Error(error);
        }
        if (!checkUser || !(await bcrypt.compare(password, checkUser.password))) {
            return null;
        }
        let { user, error: err } = await this.userRepo.findById(checkUser.id);
        if (err) {
            throw new Error(err);
        }
        delete user.password;
        return user;
    }
    async register({
        username,
        password,
        email,
        phone_no,
        address,
        avatar_url,
        birthday,
        fname,
        lname,
        isTeacher,
        data
    }) {
        let { error } = await this.userRepo.create({
            username,
            password,
            email,
            phone_no,
            address,
            avatar_url,
            birthday,
            fname,
            lname,
            isTeacher,
            data
        });
        if (error) {
            throw new Error(error);
        }
    }
}

module.exports = {
    AuthService
};