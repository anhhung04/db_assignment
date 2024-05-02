const { IService } = require('../utils/service');
const { ResourceRepo } = require('../repository/resource');
const { UserRepo } = require("../repository/user");
const { v4: uuidv4 } = require('uuid');
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
            access = permissions?.read || false;
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

    async createResource({ type, lessonId, resource }) {
        let { row: learningResource, error } = await this.resourceRepo.createInTable({
            table: "learning_resources",
            createObj: {
                id: uuidv4(),
                title: resource.title,
                download_url: resource.download_url,
            }
        });
        if (error) {
            throw new Error("Failed to create resource");
        }
        delete resource.title;
        delete resource.download_url;
        let { row, error: resourceError } = await this.resourceRepo.createInTable({
            table: type,
            createObj: {
                ...resource,
                id: learningResource.id
            }
        });
        if (resourceError) {
            throw new Error("Failed to create resource");
        }
        let { error: lessonResourceError } = await this.resourceRepo.createInTable({
            table: "lesson_resources",
            createObj: {
                lesson_id: lessonId,
                resource_id: learningResource.id,
                resource_type: type
            }
        });
        if (lessonResourceError) {
            throw new Error("Failed to create resource");
        }
        return row;
    }
}

module.exports = {
    ResourceService
};