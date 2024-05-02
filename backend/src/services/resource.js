const { IService } = require('../utils/service');
const { ResourceRepo } = require('../repository/resource');
const { UserRepo } = require("../repository/user");
class ResourceService extends IService {
    constructor(req) {
        super(req);
        this.resourceRepo = new ResourceRepo();
        this.userRepo = new UserRepo();
    }

    async fetchResource({ id, type }) {
        let { permissions, error } = this.userRepo.fetchUserPermissions({
            userId: this._currentUser.id,
            resourceId: id
        });
        let access = false;
        if (!error) {
            access = permissions.read;
        }
        access = access || await this.resourceRepo.checkStudentAccess({
            userId: this._currentUser.id,
            resourceId: id
        });
        if (!access) {
            throw new Error("Access denied");
        }
        let { resource, error: resourceError } = await this.resourceRepo.findOne({
            table: type,
            id
        });
        if (resourceError) {
            throw new Error("Resource not found");
        }
        return resource;
    }
}


module.exports = {
    ResourceService
};