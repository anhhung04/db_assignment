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
        const { user, error } = await this.userRepo.create({
            username,
            password: await bcrypt.hash(password, 10),
            email,
            phone_no,
            address,
            avatar_url,
            birthday,
            fname,
            lname,
            display_name: `${fname} ${lname}`
        });
        if (error) {
            throw new Error(error);
        }
        let { error: err } = await this.userRepo.createUserType({
            userId: user.id,
            userType: isTeacher ? "teachers" : "students",
            typeData: data
        });
        if (err) {
            throw new Error(err);
        }
        return user;
    }
}

module.exports = {
    AuthService
};