const { IService } = require('../utils/service');
const { ResourceRepo } = require('../repository/resource');
const { UserRepo } = require("../repository/user");
class ResourceService extends IService {
    constructor(req) {
        super(req);
        this.resourceRepo = new ResourceRepo();
        this.userRepo = new UserRepo();
    }

    async getVideo(id) {
        let userId = this._currentUser.id;
        let { resource: video, error } = await this.resourceRepo.findOne({ table: 'videos', id });
        if (error) {
            throw new Error(error);
        }
        let permissions = await this.userRepo.fetchUserPermissions({ userId, resourceId: video.course_id });
        return permissions
    }
}


module.exports = {
    ResourceService
};