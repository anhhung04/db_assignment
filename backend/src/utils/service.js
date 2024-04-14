const { UserRepo } = require("../repository/user");
const { HTTPException } = require("../utils/error");
const { STATUS_CODE } = require("../utils/response");
const logger = require("./log");

const UserRole = Object.freeze({
    ADMIN: 'admin',
    USER: 'user',
    TEACHER: 'teacher',
    STUDENT: 'student',
    OPERATOR: 'operator'
});

const ActionType = Object.freeze({
    CREATE: 'create',
    READ: 'read',
    UPDATE: 'update',
    DELETE: 'delete'
});

class IService {
    /**
     * @param {Request} request
     * @returns {Service}
     */
    constructor(request) {
        this._currentUser = request.session.user;
        return new Proxy(this, {
            /**
             * 
             * @param {Service} target 
             * @param {String} prop 
             */
            get(target, prop) {
                const originMethod = target[prop];
                if (typeof originMethod !== 'function') {
                    return originMethod;
                }
                const currentUser = target["_currentUser"];
                return async function (...args) {
                    const inputArgs = args[0];
                    try {
                        let userRole = currentUser?.role?.toLowerCase();
                        let acl = inputArgs?.acl;
                        if (
                            userRole === UserRole.ADMIN
                            || !acl
                            || acl.indexOf(userRole) !== -1
                            || currentUser.generalPermissions[inputArgs?.actionType] === true
                        ) {
                            return await originMethod.apply(target, args);
                        }
                        if (inputArgs.resourceId && inputArgs.actionType && currentUser.id) {
                            const userRepo = new UserRepo();
                            await userRepo.begin();
                            const permissions = await userRepo.fetchUserPermissions({
                                userId: currentUser.id,
                                resourceId: inputArgs.resourceId
                            });
                            userRepo.close();
                            if (permissions[inputArgs.actionType]) {
                                return await originMethod.apply(target, args);
                            }
                        }
                    } catch (err) {
                        logger.error(err);
                    }
                    throw new HTTPException({
                        code: STATUS_CODE.HTTP_401_UNAUTHORIZED,
                        message: "Unauthorized",
                    });
                };
            }
        });
    }
}

module.exports = {
    UserRole,
    ActionType,
    IService
};