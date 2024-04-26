const { IRepo } = require("./index");
const logger = require("../utils/log");


class ActivityRepo extends IRepo {
    constructor() {
        super();
    }
    async create({ activistId, action, resourceId, note = "" }) {
        try {
            let results = await this.exec({
                query: `
                INSERT INTO activities (activist_id, resource_id, action, note)
                VALUES ($1, $2, $3, $4)
                RETURNING *
                `,
                args: [activistId, resourceId, action, note]
            });
            if (results.rowCount !== 1) {
                throw new Error("Insert activity error");
            }
            return {
                activity: results.rows[0],
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                activity: null,
                error: err
            };
        }
    }
}

module.exports = {
    ActivityRepo,
    ACTION: Object.freeze({
        READ: 'read',
        CREATE: 'create',
        UPDATE: 'update',
        DELETE: 'delete',
    }),
    STATUS: Object.freeze({
        SUCCESS: 'success',
        FAILED: 'failed'
    })
};

