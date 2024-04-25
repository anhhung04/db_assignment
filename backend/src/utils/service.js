const { UserRepo } = require("../repository/user");
const { ActivityRepo } = require("../repository/activity");
const { HTTPException } = require("../utils/error");
const { STATUS_CODE } = require("./http");
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
     * @returns {IService}
     */
    constructor(request) {
        this._currentUser = request.session.user;
        this._activityRepo = new ActivityRepo();
        this._request = request;
        return new Proxy(this, {
            /**
             * 
             * @param {IService} target 
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
                            return originMethod.apply(target, args);
                        }
                        if (inputArgs.resourceId && inputArgs.actionType && currentUser.id) {
                            const userRepo = new UserRepo();
                            await userRepo.begin();
                            const { permissions, error } = await userRepo.fetchUserPermissions({
                                userId: currentUser.id,
                                resourceId: inputArgs.resourceId
                            });
                            userRepo.end();
                            if (error) {
                                throw new Error(error);
                            }
                            if (permissions[inputArgs.actionType]) {
                                return originMethod.apply(target, args);
                            }
                        }
                    } catch (err) {
                        logger.debug(err);
                        throw new HTTPException({
                            code: STATUS_CODE.HTTP_500_INTERNAL_SERVER_ERROR,
                            message: "Internal server error",
                        });
                    }
                    throw new HTTPException({
                        code: STATUS_CODE.HTTP_401_UNAUTHORIZED,
                        message: "Unauthorized",
                    });
                };
            }
        });
    }

    /**
     * Log activity
     */
    async logActivity({ action, resourceId, note = "" }) {
        try {
            await this._activityRepo.begin();
            let { activity, error } = await this._activityRepo.create({
                activistId: this._currentUser?.id || '00000000-00000000-00000000-00000000',
                action,
                resourceId,
                note
            });
            if (error) {
                throw new Error(error);
            }
            await this._activityRepo.end();
            return activity !== null;
        } catch (err) {
            logger.debug(err);
            return false;
        }
    }
}

module.exports = {
    UserRole,
    ActionType,
    IService
};